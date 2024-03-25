# @summary Create a file which allows many resources to contribute content.
#
# This is a convenience function that uses a collection to handle the problem
# of allowing portions of a file to be defined in many places. The file will
# be generate from a template, with data collated from any number of
# `collection::file::fragment` resources.
#
# EPP templates will receive two parameters:
#   * `Any $data` - The contents of all `data` parameters from the collection
#                   merged
#   * 'Array $items` - An array containing each `data` parameter from the
#                      collection, in order.
#
# ERB templates can access these two variables as `@data` and `@items`.
#
# As a convenience, a small set of templates are predefined within the
# collections module to suit a few use cases:
#
# #### `collections/concat.epp`
# (Also .erb)
# This template allows constructing a file from multiple content blocks, with
# ordering based upon an optional `order` key. Fragments should contain a
# `content` key. Order will default to 1000 if it is not supplied.
#
# #### `collections/yaml.epp`
# (Also .erb)
# This template will output the collected data as a YAML document
#
# #### `collections/json.epp`
# (Also .erb)
# This template will output the collected data as a JSON document
#
# @example
#   ## Create a file from multiple string content blocks, with ordering
#
#   collections::file { '/etc/motd':
#     collector => 'motd',
#     template  => 'collections/concat.epp',
#     data      => {
#       order   => 1,
#       content => file('my-module/motd-header'),
#     },
#     file      => {
#       owner   => 'root',
#       group   => 'root',
#       mode    => '0444',
#     },
#   }
#   collections::file::fragment { 'Add an unauthorised access warning':
#     target    => 'motd',
#     data      => {
#       order   => 2,
#       content => file('my-module/motd-unathorised-warning'),
#     },
#   }
#
#   ## Create a yaml file using multiple merged values
#
#   collections::file { '/etc/service/config.yaml':
#     collector => 'service-config',
#     template  => 'collections/yaml.epp',
#     file      => {
#       owner   => 'root',
#       group   => 'service',
#       mode    => '0640',
#     },
#   }
#   collections::file::fragment { 'Set the user and group':
#     target  => 'service-config',
#     data    => {
#       user  => 'serviceuser',
#       group => 'serviceuser',
#     },
#   }
#
# @param [String[1]] collector
#   The name of this collection
#
# @param [Optional[String[3]]] template
#   The name of a template to use. This should be a String in the form of `modulename/filename`.
#   Either this or `template_body` (the actual template code) must be passed.
#
# @param [Optional[String]] template_body
#   The template code to use (content of a template file, rather than a path).
#   Either this or `template` (a path to a template in a module) must be passed.
#
# @param [Enum['epp','erb','auto']] template_type
#   The template language used. The default is `auto`, which will default to 'erb'
#   unless a filename template is passed that ends in `.epp`.
#
# @param [Any] data
#   Optional. Initial data for the collection.
#   If provided, a `collection::append` resource named `<collectionname>::auto-initial-data` will
#   be created.
#
# @param [Hash[String, Any]] file
#   Parameters to pass to the `file` resource which will be created by this collection.
#   Most values will be passed through, but `source` or `content` will be removed
#   (As allowing them would be ambiguous) and `ensure` will only be allowed if set to
#   `absent`, `file` or `present`.
#
# @param [Hash[String,Variant[Boolean,String]]] merge_options
#   Default: { keep_array_duplicates => true } (for compatability with datacat)
#   Options to pass to the Ruby `deep_merge` gem. See the [options reference](https://github.com/danielsdeleo/deep_merge?tab=readme-ov-file#options) for details.
#
# @param [Boolean] reverse_merge_order
#   Default: false
#   Give merge priority to items later in the set
#
define collections::file (
  String[1] $collector,

  Optional[String[3]] $template = undef,
  Optional[String] $template_body = undef,
  Enum['epp','erb','auto'] $template_type = 'auto',
  Any $data = undef,
  Hash[String,Variant[Boolean,String]] $merge_options = {},

  Hash[String, Any] $file = {},
  Boolean $reverse_merge_order = false,
) {
  if $template == undef and $template_body == undef {
    fail("Exactly one of 'template' or 'template_body' must be passed to 'collections::file'")
  }
  if $template != undef and $template_body != undef {
    fail("Exactly one of 'template' or 'template_body' must be passed to 'collections::file'")
  }

  $ensure_safe_values = {
    content => [],
    source  => [],
    ensure  => [absent, file, present],
  }
  $safe_file_params = $file.filter |$key, $value| {
    if $key in $ensure_safe_values {
      if ! $value in $ensure_safe_values[$key] {
        notify { "Warning: Removing '${key}' from file parameters for Collections::File['${title}']: Value is unsafe": }
        next(false)
      }
    }
    true
  }

  if $data != undef {
    $initial_items = [$data]
  } else {
    $initial_items = []
  }

  collections::create { $collector:
    initial_items => $initial_items,
  }

  $set_default_file_path = {
    path => $title,
  }

  collections::register_executor { "collections::file::writer::${collector}":
    target     => $collector,
    resource   => 'collections::file::writer',
    parameters => {
      file                => collections::deep_merge($file, $set_default_file_path),
      template            => $template,
      template_body       => $template_body,
      template_type       => $template_type,
      merge_options       => $merge_options,
      reverse_merge_order => $reverse_merge_order,
    },
  }
}
