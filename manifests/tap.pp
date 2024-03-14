# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   collections::tap { 'namevar': }
define collections::tap (
  String $target,
  Any $item
) {
  notify { "Collections::Tap: ${title}":
    message => {
      item => $item
    }
  }
}
