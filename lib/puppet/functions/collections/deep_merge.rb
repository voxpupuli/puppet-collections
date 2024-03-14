# frozen_string_literal: true
require 'deep_merge'

Puppet::Functions.create_function(:"collections::deep_merge") do
  dispatch :deep_merge do
    required_param 'Any', :dest
    required_param 'Any', :source
    optional_param 'Hash[String, Variant[Boolean,String]]', :options
    return_type 'Any'
  end

  def deep_merge(dest, source, options = {})
    wrapped_source = { data: source.frozen? ? source.dup : source }
    wrapped_dest = { data: dest.frozen? ? dest.dup : dest }
    options_with_syms = options.transform_keys(&:to_sym)

    result = wrapped_dest.deep_merge(wrapped_source, options_with_syms)

    return result[:data]
  end

end
