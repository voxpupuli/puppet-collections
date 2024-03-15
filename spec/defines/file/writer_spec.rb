# frozen_string_literal: true

require 'spec_helper'

describe 'collections::file::writer' do
  let(:title) { 'writer' }
  let(:params) do
    {
      target: 'foo',
      items: [ {} ],
      file: {
        path: '/foo/bar',
      },
      template: 'collections/file-test.erb'
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
