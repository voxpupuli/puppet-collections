# frozen_string_literal: true

require 'spec_helper'

describe 'collections::iterator' do
  let(:title) { 'iterator' }
  let(:params) do
    {
      items: [],
      actions: [],
      executors: []
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it 'creates checkpoints' do
        ['iterator'].each do |title|
          %w[before-executors after-executors before-actions after-actions completed].each do |stage|
            is_expected.to contain_collections__checkpoint("collections::#{title}::#{stage}")
          end
        end
      end

      it 'creates a commit resource' do
        is_expected.to contain_collections__iterator('iterator')
        is_expected.to contain_collections__commit('iterator')
      end
    end
  end
end
