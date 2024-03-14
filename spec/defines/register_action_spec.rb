# frozen_string_literal: true

require 'spec_helper'

describe 'collections::register_action' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      target: 'foo',
      resource: 'bar'
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
