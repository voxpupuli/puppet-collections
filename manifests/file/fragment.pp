# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   collections::file::fragment { 'namevar': }
define collections::file::fragment (
  String[1] $target,
  Any $data
) {

  collections::append { "${target}::${title}":
    target => "collections::file::${target}",
    item   => $data
  }
}
