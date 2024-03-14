# @summary Collections debugging - print the set of items passed in
# 
# This provides an example of an executor and possibly a useful debugging tool.
#
# @example
#   collections::debug_list { 'namevar': }
define collections::debug_executor (
  String $target,
  Array $items,
  Any $context = undef,
) {
  notify { "Collection ${target}: ${items}": }
}
