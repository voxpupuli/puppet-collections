# @summary Collections debugging - print the set of items passed in
#
# This provides an example of an executor and possibly a useful debugging tool.
# In normal use, you would never create a resource of this type manually, it
# would instead be created by `collections::register_executor`.
#
# @see collections::register_executor
#
# @example
#
#   collections::register_executor { 'Debug: Print all items added to the collection':
#     target   => 'an-exiting-collection',
#     resource => 'collections::debug_executor',
#   }
#
# @param [String[1]] target
#   Passed in by `collections::commit` when creating this resource. It indicates the
#   name of the collection that it was spawned from, to allow any
#
# @param [Array[Any]] items
#   Passed in by `collections::commit` when creating this resource. It contains an
#   array of all the items added to this collection using `collections::append`
#
define collections::debug_executor (
  String[1] $target,
  Array[Any] $items,
) {
  notify { "Collection ${target}:":
    message => { items => $items },
  }
}
