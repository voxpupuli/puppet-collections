# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   collections::register_action { 'namevar': }
define collections::register_action (
  String $target,
  String $resource,
  Boolean $wrapped = false
) {

  if $wrapped {
    Collections::Iterator <| title == $target |> {
      resources +> [ $resource ],
      wrapped   +> [ $resource ]
    }
  } else {
    Collections::Iterator <| title == $target |> {
      resources +> [ $resource ],
    }
  }
}
