# @api private
# @summary An empty resource recording stages within a collection
#
# This exists to allow other modules to depend upon various stages
# within a collection run.
#
define collections::checkpoint (
) {
  # Does nothing, but exists to allow other resources to handle ordering
}
