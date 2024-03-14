# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   collections::debug_list { 'namevar': }
define collections::debug_list (
  String $target,
  Array $items,
  Any $context = undef
) {
  notify { "Collection ${target}: ${items}": }
}
