# @api private
# @summary Write collected data to a file
#
# This is the executor component of `collections::file`. It will not normally
# be instantiated directly. Instead, declaring a `collections::file` resource
# will cause the creation of a `collections::file::writer` to receive the
# collected stream of data and write it to a file.
#
# By default, the merge is done giving priority to items earlier in the set -
# if the same key is present in two hashes, the value defined first "wins".
# You can reverse this behaviour by passing setting `reverse_merge_order` to
# true.
#
# @param [String[1]] target
#   Passed in by `collections::commit` when creating this resource. It indicates the
#   name of the collection that it was spawned from, to allow any
#
# @param [Array[Any]] items
#   Passed in by `collections::commit` when creating this resource. It contains an
#   array of all the items added to this collection using `collections::append`
#
# @param [Hash[String,Any]] file
#   Passed in by `collections::commit` when creating this resource. It contains the
#   the parameters which will be used to configure the `file` resource.
#
# @param [Optional[String[3]]] template
#   Passed in by `collections::commit` when creating this resource. It contains the
#   name of a template, in 'module/filename' form.
#
# @param [Optional[String]] template_body
#   Passed in by `collections::commit` when creating this resource. It contains the
#   actual template code that will be executed.
#
# @param [Enum['epp','erb','auto']] template_type
#   The template language used. The default is `auto`, which will default to 'erb'
#   unless a filename template is passed that ends in `.epp`.
#
# @param [Hash[String,Variant[Boolean,String]]] merge_options
#   Default: {}
#   Options to pass to the Ruby `deep_merge` gem. See the [options reference](https://github.com/danielsdeleo/deep_merge?tab=readme-ov-file#options) for details.
#
# @param [Boolean] reverse_merge_order
#   Default: false
#   Give merge priority to items later in the set
define collections::file::writer (
  String[1] $target,
  Array[Any] $items,
  Hash[String,Any] $file,
  Optional[String[3]] $template = undef,
  Optional[String] $template_body = undef,
  Enum['epp','erb','auto'] $template_type = 'auto',
  Hash[String,Variant[Boolean,String]] $merge_options = {},
  Boolean $reverse_merge_order = false,
) {
  # Collect the items together
  $data = $items.reduce |$memo, $value| {
    if $reverse_merge_order {
      collections::deep_merge($value, $memo, $merge_options)
    } else {
      collections::deep_merge($memo, $value, $merge_options)
    }
  }

  $epp_params = {
    items => $items,
    data  => $data
  }

  case $template_type {
    'auto': {
      if $template != undef and $template =~ /(?i:\.epp)$/ {
        $content = epp($template, $epp_params)
      } elsif $template != undef {
        $content = template($template)
      } else {
        $content = inline_template($template_body)
      }
    }
    'erb': {
      if $template != undef {
        $content = template($template)
      } else {
        $content = inline_template($template_body)
      }
    }
    'epp': {
      if $template != undef {
        $content = epp($template, $epp_params)
      } else {
        $content = inline_epp($template_body, $epp_params)
      }
    }
  }

  file { $file['path']:
    *       => $file,
    content => $content,
  }
}
