# frozen_string_literal: true

require 'spec_helper'

describe 'collections::deep_merge' do
  it { is_expected.to run.with_params([1], [2]).and_return([1, 2]) }
  it { is_expected.to run.with_params({}, {}).and_return({}) }
  it { is_expected.to run.with_params({ a: 1 }, { b: 2 }).and_return({ a: 1, b: 2 }) }
  it { is_expected.to run.with_params(nil).and_raise_error(StandardError) }
end
