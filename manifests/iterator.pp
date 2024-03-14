# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   collections::iterator { 'namevar': }
define collections::iterator (
  Hash[String, Any] $defaults = {},
  Array[String] $resources,
  Array[Any] $items,
  Array[String] $wrapped,
  Array[Any] $executors
) {
  $executors.each |$group| {
    $resource = $group['r']
    $context = $group['c']
    ensure_resource(
      $resource,
      "${title}::executor",
      collections::deep_merge({
          target   => $title,
          items    => $items,
          context  => $context,
        }, $defaults
      )
    )
  }

  $items.each |$itemcount, $item| {
    $resources.each |$resourcecount, $resource| {
      if $resource in $wrapped {
        ensure_resource(
          $resource,
          "${title}:${resourcecount}:${itemcount}",
          {
            target => $title,
            item   => $item
          }
        )
      } else {
        ensure_resource(
          $resource,
          "${title}:${resourcecount}:${itemcount}",
          deep_merge($item, { target => $title }),
          $defaults
        )
      }
    }
  }
}
