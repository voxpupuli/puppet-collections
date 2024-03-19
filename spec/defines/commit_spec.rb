# frozen_string_literal: true

require 'spec_helper'

describe 'collections::commit' do
  let(:title) { 'commit' }
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
        ['commit'].each do |title|
          %w[before-executors after-executors before-actions after-actions completed].each do |stage|
            is_expected.to contain_collections__checkpoint("collections::#{title}::#{stage}")
          end
        end
      end
    end
  end
end
