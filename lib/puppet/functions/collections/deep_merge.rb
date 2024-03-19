# frozen_string_literal: true

require 'deep_merge'

# @summary Wrapper for the Ruby deep_merge gem
#
# Returns a copy of dest with source merged into it
#
# @see https://github.com/danielsdeleo/deep_merge?tab=readme-ov-file#options
Puppet::Functions.create_function(:'collections::deep_merge') do
  # @param dest
  #   The destination object, which will be overridden by the contents of source
  #
  # @param source
  #   The source object, which will override the contents of dest
  #
  # @param options
  #   Options for the deep_merge method.
  dispatch :deep_merge do
    required_param 'Any', :dest
    required_param 'Any', :source
    optional_param 'Hash[String, Variant[Boolean,String]]', :options
    return_type 'Any'
  end

  def deep_merge(dest, source, options = {})
    # Wrap both source and dest into hashes, as deep_merge requires the top level object
    # to be a hash.
    wrapped_source = { data: source }

    # deep_merge will alter the destination object, so do a deep clone of it for safety.
    wrapped_dest = { data: Marshal.load(Marshal.dump(dest)) }

    # Options are expected to be a hash with Symbol keys.
    options_with_syms = options.transform_keys(&:to_sym)

    result = wrapped_dest.deep_merge(wrapped_source, options_with_syms)

    result[:data]
  end
end
