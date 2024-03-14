# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   collections::file { 'namevar': }
define collections::file (
  String[1] $collector,

  String[1] $template,
  Any $data = {},
  Hash[String, Any] $file = {},

  String[1] $path = $title,
  Enum[absent, present] $ensure = present,
) {

  collections::create { "collections::file::${collector}":
  }

  $context = {
    file     => collections::deep_merge($file, {path => $title}),
    template => $template,
    data     => $data
  }

  collections::register_executor { "collections::file::writer::${collector}":
    target   => "collections::file::${collector}",
    resource => 'collections::file::writer',
    context  => $context
  }
}
