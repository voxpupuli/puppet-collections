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

      let(:pre_condition) do
        <<EOF
  collections::file { '/tmp/collections-file-test':
    collector => 'file-test',
    template  => 'collections/file-test.erb',
    file      => {
      # options to be passed to the file resource
      owner   => root,
      group   => root,
      mode    => '0644'
    },
    data      => {
      list    => [ 1 ],
      hash    => { one => 1 },
    },
  }

  collections::register_executor { 'collections::file::debug::file-test':
    target   => 'file-test',
    resource => 'collections::debug_executor'
  }

  collections::append { 'Add two':
    target => 'file-test',
    data   => {
      list => [ 2 ],
      hash => { two => 2 },
      repl => { not_two => 7 },
    },
  }

  collections::append { 'Overwrite':
    target => 'file-test',
    data   => {
      hash => { one => 3 },
      repl => { not_two => 2 },
    },
    require => Collections::Append['Add two']
  }
EOF
      end

      it { is_expected.to compile }

      # it { generate('Creates a file') }
      ### BEGIN GENERATED TESTS: Creates a file ###

      it 'creates checkpoints' do
        is_expected.to contain_collections__checkpoint('collections::file-test::before-executors')
        is_expected.to contain_collections__checkpoint('collections::file-test::after-executors')
        is_expected.to contain_collections__checkpoint('collections::file-test::before-actions')
        is_expected.to contain_collections__checkpoint('collections::file-test::after-actions')
        is_expected.to contain_collections__checkpoint('collections::file-test::completed')
      end

      it 'Creates a file' do
        is_expected.to contain_collections__file('/tmp/collections-file-test').with(
          name: '/tmp/collections-file-test',
          collector: 'file-test',
          template: 'collections/file-test.erb',
          file: {
            'owner' => 'root',
            'group' => 'root',
            'mode' => '0644',
          },
          data: {
            'list' => [
              1,
            ],
            'hash' => {
              'one' => 1,
            },
          },
        )
        is_expected.to contain_collections__append('Add two').with(
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
        is_expected.to contain_collections__append('Overwrite').with(
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
        is_expected.to contain_collections__create('file-test').with(
          target: 'file-test',
          defaults: {},
        )
        is_expected.to contain_collections__register_executor('collections::file::writer::file-test').with(
          name: 'collections::file::writer::file-test',
          target: 'file-test',
          resource: 'collections::file::writer',
          parameters: {
            'file' => {
              'owner' => 'root',
              'group' => 'root',
              'mode' => '0644',
              'path' => '/tmp/collections-file-test',
            },
            'template' => 'collections/file-test.erb',
          },
        )
        is_expected.to contain_collections__register_executor('collections::file::debug::file-test').with(
          name: 'collections::file::debug::file-test',
          target: 'file-test',
          resource: 'collections::debug_executor',
        )
        is_expected.to contain_collections__append('Add two').with(
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
        is_expected.to contain_collections__append('Overwrite').with(
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
        is_expected.to contain_collections__iterator('file-test').with(
          items: [
            {
              'list' => [ 1 ],
              'hash' => { 'one' => 1 }
            },
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
          actions: [],
          executors: [
            {
              'resource' => 'collections::debug_executor',
              'parameters' => {},
            },
            {
              'resource' => 'collections::file::writer',
              'parameters' => {
                'file' => {
                  'owner' => 'root',
                  'group' => 'root',
                  'mode' => '0644',
                  'path' => '/tmp/collections-file-test',
                },
                'template' => 'collections/file-test.erb',
              },
            },
          ],
        )
        is_expected.to contain_collections__file__writer('file-test::executor').with(
          target: 'file-test',
          items: [
            {
              'list' => [
                1,
              ],
              'hash' => {
                'one' => 1
              },
            },
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
          'file' => {
            'owner' => 'root',
            'group' => 'root',
            'mode' => '0644',
            'path' => '/tmp/collections-file-test',
          },
          'template' => 'collections/file-test.erb',
        )
        is_expected.to contain_collections__debug_executor('file-test::executor').with(
          target: 'file-test',
          items: [
            {
              'list' => [
                1,
              ],
              'hash' => {
                'one' => 1
              },
            },
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
        )
        is_expected.to contain_notify('Collection file-test:').with(
          message: {
            'items'=>[{ 'list' => [1], 'hash' => { 'one' => 1 } }, { 'list' => [2], 'hash' => { 'two' => 2 }, 'repl' => { 'not_two' => 7 } }, { 'hash' => { 'one' => 3 }, 'repl' => { 'not_two' => 2 } } ]
          }
        )
        is_expected.to contain_file('/tmp/collections-file-test').with(
          path: '/tmp/collections-file-test',
          owner: 'root',
          group: 'root',
          mode: '0644',
          content: '{"hash"=>{"one"=>3, "two"=>2}, "repl"=>{"not_two"=>2}, "list"=>[2, 1]}',
        )

        is_expected.to contain_collections__create('foo').with(
          target: 'foo',
          defaults: {},
        )
        is_expected.to contain_collections__register_executor('collections::file::writer::foo').with(
          target: 'foo',
          resource: 'collections::file::writer',
          parameters: {
            'file' => {
              'path' => '/foo/bar',
            },
            'template' => 'collections/file-test.erb',
          },
        )
        is_expected.to contain_collections__iterator('foo').with(
          items: [],
          actions: [],
          executors: [
            {
              'resource' => 'collections::file::writer',
              'parameters' => {
                'file' => {
                  'path' => '/foo/bar',
                },
                'template' => 'collections/file-test.erb',
              },
            },
          ],
        )
        is_expected.to contain_collections__file__writer('foo::executor').with(
          target: 'foo',
          items: [],
          'file' => {
            'path' => '/foo/bar',
          },
          'template' => 'collections/file-test.erb',
        )
        is_expected.to contain_file('/foo/bar').with(
          path: '/foo/bar',
          content: '',
        )
      end
      ### END GENERATED TESTS: Creates a file ###
    end
  end
end
