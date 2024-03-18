# @summary Register a defined type to be run once, for all items in a collection.
#
# In the collections module, an `executor` is a defined_type that will be called
# once, with all items in the collection passed to it as the `items` parameter
#
# @example
#   collections::create { 'admin_users': }
#
#   collections::register_executor { 'Admin users get database access':
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
#   database::add_admin_access { 'admin_users::executor',
#     target => admin_users,
#     items  => [
#       {
#         user => 'Alice',
#         uid  => 1001,
#         home => '/home/alice',
#       },
#       {
#         user => 'Bob',
#         uid  => 1002,
#         home => '/home/bob',
#       },
#     },
#     require => Service['database']
#   }
#
# @param [String[1]] target
#   The name of the collection to configure
#
# @param [String[1]] resource
#   The name of a defined_type
#
# @param [Hash[String,Any]] parameters
#   Optional parameters that will be passed to the action resource when created
#
define collections::register_executor (
  String[1] $target,
  String[1] $resource,
  Hash[String,Any] $parameters = {}
) {
  $executor = {
    resource   => $resource,
    parameters => $parameters,
  }

  Collections::Iterator <| title == $target |> {
    executors +> [$executor]
  }
}
