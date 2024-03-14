# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   collections::register_executor { 'namevar': }
define collections::register_executor (
  String $target,
  String $resource,
  Any $context = {}
) {

  Collections::Iterator <| title == $target |> {
    executors +> [ {r => $resource, c => $context} ]
  }
}
