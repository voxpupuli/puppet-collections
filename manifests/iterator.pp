# @summary The resource that calls actions and executors upon a collection
#
# Each collection has a `collection::iterator` which collects the items being
# appended to it and subsequently creates actions to operate on all the items
# together ('executors') or for each item in turn ('actions').
#
# In normal use, you would never create a `collection::iterator` directly -
# instead, it is created for you by either `collection::create` or 
# `collection::file`.
#
# @example
#   collections::create { 'foo':
#   }
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

  Array[Struct[{resource=>String,parameters=>Hash}]] $executors,
  Array[Struct[{resource=>String,parameters=>Hash}]] $actions,
) {
  collections::checkpoint { "collections::${title}::before-executors":
  }
  collections::checkpoint { "collections::${title}::after-executors":
    require => Collections::Checkpoint["collections::${title}::before-executors"],
  }
  collections::checkpoint { "collections::${title}::before-actions":
    require => Collections::Checkpoint["collections::${title}::after-executors"],
  }
  collections::checkpoint { "collections::${title}::after-actions":
    require => Collections::Checkpoint["collections::${title}::before-actions"],
  }
  collections::checkpoint { "collections::${title}::completed":
    require => Collections::Checkpoint["collections::${title}::after-actions"],
  }

  # Option for deep_merge to allow merging require/before cleanly
  # (require => "foo" will merge into require => ["bar", "baz"] to make ["bar", "baz", "foo"])
  $extend_arrays = {
    extend_existing_arrays => true,
  }

  # Generate the base require/before for all executor
  $executor_ordering = {
    require => [
      Collections::Checkpoint["collections::${title}::before-executors"],
    ],
    before  => [
      Collections::Checkpoint["collections::${title}::after-executors"],
      Collections::Checkpoint["collections::${title}::before-actions"],
    ],
  }

  # Executors are called once, with all the items as a parameter
  $executors.each |$group| {
    create_resources(
      $group['resource'],
      {
        "${title}::executor" => {
          target  => $title,
          items   => $items,
        }
      },
      collections::deep_merge($executor_ordering, $group['parameters'], $extend_arrays),
    )
  }

  # Generate the base require/before for all actions
  $action_ordering = {
    require => [
      Collections::Checkpoint["collections::${title}::after-executors"],
      Collections::Checkpoint["collections::${title}::before-actions"],
    ],
    before  => [
      Collections::Checkpoint["collections::${title}::after-actions"],
      Collections::Checkpoint["collections::${title}::completed"],
    ],
  }

  # We only need to generate these once, then create_resources can run once per
  # resource type.
  $item_hash = $items.reduce({}) |$memo, $item| {
    $index = $memo.length + 1
    $memo + {
      "${title}::${index}" => {
        target => $title,
        item   => $item,
      },
    }
  }

  # Actions are called per item
  $actions.each |$group| {
    create_resources(
      $group['resource'],
      $item_hash,
      collections::deep_merge($action_ordering, $group['parameters'], $extend_arrays),
    )
  }
}
