# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   collections::append { 'namevar': }
define collections::append (
  String $target,
  Any $item
) {

  Collections::Iterator <| title == $target |> {
    items +> [ $item ]
  }
}
