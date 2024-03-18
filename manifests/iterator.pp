# @api private
# @summary Wrapper resource to allow predictable resource ordering
#
# This is an internal type. The collections module works by appending
# to lists in a resource, and thus depends entirely upon Puppet's
# resource ordering to ensure that all of the appends have actually
# executed before we perform any actions. `collections::iterator`
# defines and wraps around a `collections::commit` resource, and
# provides the necessary structure upon which to insert dependency
# constraints that make collections work.
#
# @param [Array[Any]] items
#   The collected items which will be processed by actions and executors
#
# @param [Array[Struct[{resource=>String,parameters=>Hash}]]] executors
#   The names of defined_types which will be instantiated, passing in the
#   complete item set as `items`
#
# @param [Array[Struct[{resource=>String,parameters=>Hash}]]] actions
#   The names of defined_types which will be instantiated once for each
#   item in the collection, passing that in as `item`.
#
define collections::iterator (
  Array[Any] $items,

  Array[Struct[{ resource=> String,parameters=> Hash }]] $executors,
  Array[Struct[{ resource=> String,parameters=> Hash }]] $actions,
) {
  collections::commit { $title:
    items     => $items,
    executors => $executors,
    actions   => $actions,
  }
}
