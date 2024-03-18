# frozen_string_literal: true

require 'spec_helper'

describe 'collections::tap' do
  let(:title) { 'tap' }
  let(:params) do
    {
      target: 'foo',
      item: 1
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it do
        is_expected.to contain_notify('Collections::Tap: tap').with(
          message: {
            'item' => 1,
          },
        )
      end
    end
  end
end
