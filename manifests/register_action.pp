# @summary Register a defined type to be run for each item in a collection.
#
# In the collections module, an `action` is a defined_type that will be called
# for each item added to the collection, passed in as the `item` parameter
#
# @example
#   collections::create { 'admin_users': }
#
#   collections::register_action { 'Admin users get database access':
#     target     => admin_users,
#     resource   => 'database::add_admin_access',
#     parameters => {
#       require => Service['database']
#     }
#   }
#
#   collections::append { 'Alice is an admin user':
#     target => admin_users,
#     data   => {
#       user => 'Alice',
#       uid  => 1001,
#       home => '/home/alice'
#     }
#   }
#
#   collections::append { 'Bob is an admin user':
#     target => admin_users,
#     data   => {
#       user => 'Bob',
#       uid  => 1002,
#       home => '/home/bob'
#     }
#   }
#
#   # Will result in:
#   database::add_admin_access { 'admin_users::1',
#     target => admin_users,
#     item   => {
#       user => 'Alice',
#       uid  => 1001,
#       home => '/home/alice'
#     },
#     require => Service['database']
#   }
#   database::add_admin_access { 'admin_users::2',
#     target => admin_users,
#     item   => {
#       user => 'Bob',
#       uid  => 1002,
#       home => '/home/bob'
#     },
#     require => Service['database']
#   }
#
# @param [String[1]] target
#   The name of the collection to configure
#
# @param [String[1]] resource
#   The name of a defined_type that will be created once per item
#
# @param [Hash[String,Any]] parameters
#   Optional parameters that will be passed to the action resource when created
#
define collections::register_action (
  String[1] $target,
  String[1] $resource,
  Hash[String,Any] $parameters = {}
) {
  $action = {
    resource   => $resource,
    parameters => $parameters,
  }

  Collections::Iterator <| title == $target |> {
    actions +> [$action],
  }
}
