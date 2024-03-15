# @summary Print the items received for debugging
#
# This is a debugging tool and example action. It creates a 
# notify resource for the item passed in to it.
#
# @example
#   collections::create { 'foo': }
#
#   collections::append { 'foo A':
#     target => 'foo',
#     data   => 'A'
#   }
#
#   collections::append { 'foo B':
#     target => 'foo',
#     data   => 'B'
#   }
#
#   collections::register_action { 'Debug: Print the items'
#
#   # Will result in:
#   collections::tap { 'foo:1':
#     target => 'foo',
#     item   => 'A'
#   }
#   collections::tap { 'foo:2':
#     target => 'foo',
#     item   => 'B'
#   }
#
# @param [String[1]] target
#   Passed in by `collections::iterator` when creating this resource. It indicates the
#   name of the collection that it was spawned from, to allow any 
#
# @param [Any] item
#   Passed in by `collections::iterator` when creating this resource. It contains an 
#   one item from the collection.
#
define collections::tap (
  String[1] $target,
  Any $item,
) {
  notify { "Collections::Tap: ${title}":
    message => {
      item => $item,
    },
  }
}
