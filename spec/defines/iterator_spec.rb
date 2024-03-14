# frozen_string_literal: true

require 'spec_helper'

describe 'collections::iterator' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      items: [],
      resources: [],
      wrapped: [],
      executors: []
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
