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
# @param [String[3]] template
#   Passed in by `collections::commit` when creating this resource. It contains the
#   name of a template, in 'module/filename' form.
#
# @param [Hash[String,Variant[Boolean,String]]] merge_options
#   Default: { keep_array_duplicates => true } (for compatability with datacat)
#   Options to pass to the Ruby `deep_merge` gem. See the [options reference](https://github.com/danielsdeleo/deep_merge?tab=readme-ov-file#options) for details.
#
# @param [Boolean] reverse_merge_order
#   Default: false
#   Give merge priority to items later in the set
define collections::file::writer (
  String[1] $target,
  Array[Any] $items,
  Hash[String,Any] $file,
  String[3] $template,
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

  file { $file['path']:
    *       => $file,
    content => template($template),
  }
}
