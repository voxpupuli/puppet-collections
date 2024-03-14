# frozen_string_literal: true

require 'spec_helper'

describe 'collections::file' do
  let(:title) { '/foo/bar' }
  let(:params) do
    {
      collector: 'foo',
      template: 'collections/file-test.erb'
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      # it { generate('Creates a file') }
      ### BEGIN GENERATED TESTS: Creates a file ###
      it 'Creates a file' do

        is_expected.to contain_collections__create('collections::file::foo').with(
          name: 'collections::file::foo',
          target: 'collections::file::foo',
          defaults: {},
        )
        is_expected.to contain_collections__register_executor('collections::file::writer::foo').with(
          name: 'collections::file::writer::foo',
          target: 'collections::file::foo',
          resource: 'collections::file::writer',
          context: {
            'file' => {
              'path' => '/foo/bar',
            },
            'template' => 'collections/file-test.erb',
            'data' => {},
          },
        )
        is_expected.to contain_collections__register_executor('collections::file::debug::foo').with(
          name: 'collections::file::debug::foo',
          target: 'collections::file::foo',
          resource: 'collections::debug_list',
          context: {},
        )
        is_expected.to contain_collections__iterator('collections::file::foo').with(
          name: 'collections::file::foo',
          items: [],
          resources: [],
          wrapped: [],
          executors: [
            {
              'r' => 'collections::file::writer',
              'c' => {
                'file' => {
                  'path' => '/foo/bar',
                },
                'template' => 'collections/file-test.erb',
                'data' => {},
              },
            },
            {
              'r' => 'collections::debug_list',
              'c' => {},
            },
          ],
          defaults: {},
        )
        is_expected.to contain_collections__file__writer('collections::file::foo::executor').with(
          name: 'collections::file::foo::executor',
          target: 'collections::file::foo',
          items: [],
          context: {
            'file' => {
              'path' => '/foo/bar',
            },
            'template' => 'collections/file-test.erb',
            'data' => {},
          },
        )
        is_expected.to contain_collections__debug_list('collections::file::foo::executor').with(
          name: 'collections::file::foo::executor',
          target: 'collections::file::foo',
          items: [],
          context: {},
        )
        is_expected.to contain_notify('{path => /foo/bar}').with(
          name: '{path => /foo/bar}',
        )
        is_expected.to contain_file('/foo/bar').with(
          path: '/foo/bar',
          content: '{}',
        )
        is_expected.to contain_notify('Collection collections::file::foo: []').with(
          name: 'Collection collections::file::foo: []',
        )

      end
      ### END GENERATED TESTS: Creates a file ###
    end
  end
end
