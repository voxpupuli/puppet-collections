# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   collections::file::writer { 'namevar': }
define collections::file::writer (
  String[1] $target,
  Array[Any] $items,
  Hash[String,Any] $context,
) {
  # Collect the items together
  $set = [$context['data']] + $items
  $data = $set.reduce |$memo, $value| {
    collections::deep_merge($value, $memo)
  }
  $file = $context['file']

  notify { "${file}": }

  file { $file['path']:
    *       => $file,
    content => template($context['template'])
  }
}
