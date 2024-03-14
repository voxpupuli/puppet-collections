# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   collections::create { 'namevar': }
define collections::create (
  $target = $title,
  Hash[String, Any] $defaults = {},
) {

  collections::iterator { $target:
    items     => [],
    resources => [],
    wrapped   => [],
    executors => [],
    defaults  => $defaults
  }
}
