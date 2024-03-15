# @summary Write collected data to a file
#
# This is the executor component of `collections::file`. IT will not normally
# be instantiated directly. Instead, declaring a `collections::file` resource
# will cause the creation of a `collections::file::writer` to receive the
# collected stream of data and write it to a file.
#
# @param [String[1]] target
#   Passed in by `collections::iterator` when creating this resource. It indicates the
#   name of the collection that it was spawned from, to allow any 
#
# @param [Array[Any]] items
#   Passed in by `collections::iterator` when creating this resource. It contains an 
#   array of all the items added to this collection using `collections::append`
#
# @param [Hash[String,Any]] file
#   Passed in by `collections::iterator` when creating this resource. It contains the
#   the parameters which will be used to configure the `file` resource.
#
# @param [String[3]] template
#   Passed in by `collections::iterator` when creating this resource. It contains the
#   name of a template, in 'module/filename' form.
#
define collections::file::writer (
  String[1] $target,
  Array[Any] $items,
  Hash[String,Any] $file,
  String[3] $template,
) {
  # Collect the items together
  $data = $items.reduce |$memo, $value| {
    collections::deep_merge($value, $memo)
  }

  file { $file['path']:
    *       => $file,
    content => template($template),
  }
}
