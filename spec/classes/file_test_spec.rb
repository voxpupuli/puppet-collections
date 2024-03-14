# frozen_string_literal: true

require 'spec_helper'

describe 'collections::file_test' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      # it { generate('Creates a file') }
      ### BEGIN GENERATED TESTS: Creates a file ###
      it 'Creates a file' do

        is_expected.to contain_collections__file('/tmp/collections-file-test').with(
          name: '/tmp/collections-file-test',
          collector: 'file-test',
          template: 'collections/file-test.erb',
          file: {
            'owner' => 'root',
            'group' => 'root',
            'mode' => '0644',
            'path' => '/tmp/collections-file-test',
          },
          data: {
            'list' => [
              1,
            ],
            'hash' => {
              'one' => 1,
            },
          },
          path: '/tmp/collections-file-test',
          ensure: 'present',
        )
        is_expected.to contain_collections__file__fragment('Add two').with(
          name: 'Add two',
          target: 'file-test',
          data: {
            'list' => [
              2,
            ],
            'hash' => {
              'two' => 2,
            },
            'repl' => {
              'not_two' => 7,
            },
          },
        )
        is_expected.to contain_collections__file__fragment('Overwrite').with(
          name: 'Overwrite',
          target: 'file-test',
          data: {
            'hash' => {
              'one' => 3,
            },
            'repl' => {
              'not_two' => 2,
            },
          },
        )
        is_expected.to contain_collections__create('collections::file::file-test').with(
          name: 'collections::file::file-test',
          target: 'collections::file::file-test',
          defaults: {},
        )
        is_expected.to contain_collections__register_executor('collections::file::writer::file-test').with(
          name: 'collections::file::writer::file-test',
          target: 'collections::file::file-test',
          resource: 'collections::file::writer',
          context: {
            'file' => {
              'owner' => 'root',
              'group' => 'root',
              'mode' => '0644',
              'path' => '/tmp/collections-file-test',
            },
            'template' => 'collections/file-test.erb',
            'data' => {
              'list' => [
                1,
              ],
              'hash' => {
                'one' => 1,
              },
            },
          },
        )
        is_expected.to contain_collections__register_executor('collections::file::debug::file-test').with(
          name: 'collections::file::debug::file-test',
          target: 'collections::file::file-test',
          resource: 'collections::debug_list',
          context: {},
        )
        is_expected.to contain_collections__append('file-test::Add two').with(
          name: 'file-test::Add two',
          target: 'collections::file::file-test',
          item: {
            'list' => [
              2,
            ],
            'hash' => {
              'two' => 2,
            },
            'repl' => {
              'not_two' => 7,
            },
          },
        )
        is_expected.to contain_collections__append('file-test::Overwrite').with(
          name: 'file-test::Overwrite',
          target: 'collections::file::file-test',
          item: {
            'hash' => {
              'one' => 3,
            },
            'repl' => {
              'not_two' => 2,
            },
          },
        )
        is_expected.to contain_collections__iterator('collections::file::file-test').with(
          name: 'collections::file::file-test',
          items: [
            {
              'list' => [
                2,
              ],
              'hash' => {
                'two' => 2,
              },
              'repl' => {
                'not_two' => 7,
              },
            },
            {
              'hash' => {
                'one' => 3,
              },
              'repl' => {
                'not_two' => 2,
              },
            },
          ],
          resources: [],
          wrapped: [],
          executors: [
            {
              'r' => 'collections::file::writer',
              'c' => {
                'file' => {
                  'owner' => 'root',
                  'group' => 'root',
                  'mode' => '0644',
                  'path' => '/tmp/collections-file-test',
                },
                'template' => 'collections/file-test.erb',
                'data' => {
                  'list' => [
                    1,
                  ],
                  'hash' => {
                    'one' => 1,
                  },
                },
              },
            },
            {
              'r' => 'collections::debug_list',
              'c' => {},
            },
          ],
          defaults: {},
        )
        is_expected.to contain_collections__file__writer('collections::file::file-test::executor').with(
          name: 'collections::file::file-test::executor',
          target: 'collections::file::file-test',
          items: [
            {
              'list' => [
                2,
                1,
              ],
              'hash' => {
                'two' => 2,
                'one' => 1,
              },
              'repl' => {
                'not_two' => 7,
              },
            },
            {
              'hash' => {
                'one' => 3,
                'two' => 2,
              },
              'repl' => {
                'not_two' => 2,
              },
              'list' => [
                2,
                1,
              ],
            },
          ],
          context: {
            'file' => {
              'owner' => 'root',
              'group' => 'root',
              'mode' => '0644',
              'path' => '/tmp/collections-file-test',
            },
            'template' => 'collections/file-test.erb',
            'data' => {
              'list' => [
                1,
              ],
              'hash' => {
                'one' => 1,
              },
            },
          },
        )
        is_expected.to contain_collections__debug_list('collections::file::file-test::executor').with(
          name: 'collections::file::file-test::executor',
          target: 'collections::file::file-test',
          items: [
            {
              'list' => [
                2,
              ],
              'hash' => {
                'two' => 2,
              },
              'repl' => {
                'not_two' => 7,
              },
            },
            {
              'hash' => {
                'one' => 3,
              },
              'repl' => {
                'not_two' => 2,
              },
            },
          ],
          context: {},
        )
        is_expected.to contain_notify('{owner => root, group => root, mode => 0644, path => /tmp/collections-file-test}').with(
          name: '{owner => root, group => root, mode => 0644, path => /tmp/collections-file-test}',
        )
        is_expected.to contain_file('/tmp/collections-file-test').with(
          path: '/tmp/collections-file-test',
          owner: 'root',
          group: 'root',
          mode: '0644',
          content: '{"hash"=>{"one"=>3, "two"=>2}, "repl"=>{"not_two"=>2}, "list"=>[2, 1]}',
        )
        is_expected.to contain_notify('Collection collections::file::file-test: [{list => [2], hash => {two => 2}, repl => {not_two => 7}}, {hash => {one => 3}, repl => {not_two => 2}}]').with(
          name: 'Collection collections::file::file-test: [{list => [2], hash => {two => 2}, repl => {not_two => 7}}, {hash => {one => 3}, repl => {not_two => 2}}]',
        )

      end
      ### END GENERATED TESTS: Creates a file ###
    end
  end
end
