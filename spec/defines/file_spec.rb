# frozen_string_literal: true

require 'spec_helper'

def checkpoint(title)
  it 'creates checkpoints' do
    is_expected.to contain_collections__checkpoint("collections::#{title}::before-executors")
    is_expected.to contain_collections__checkpoint("collections::#{title}::after-executors")
    is_expected.to contain_collections__checkpoint("collections::#{title}::before-actions")
    is_expected.to contain_collections__checkpoint("collections::#{title}::after-actions")
    is_expected.to contain_collections__checkpoint("collections::#{title}::completed")
  end
end

def basic_structure(title, file: true)
  checkpoint title
  it 'creates the basic structure' do
    is_expected.to contain_collections__create(title)
    is_expected.to contain_collections__iterator(title)
    is_expected.to contain_collections__commit(title)
    if file
      is_expected.to contain_collections__register_executor("collections::file::writer::#{title}").with(
        resource: 'collections::file::writer'
      )
      is_expected.to contain_collections__file__writer("#{title}::executor::1")
    end
  end
end

describe 'collections::file' do
  let(:title) { '/foo/bar' }
  let(:params) do
    {
      collector: 'foo',
      template: 'collections/yaml.erb'
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Basic test - merge items in the right order.
      let(:pre_condition) do
        <<EOF

  collections::file { '/tmp/collections-file-test':
    collector => 'file-test',
    template  => 'collections/yaml.erb',
    file      => {
      # options to be passed to the file resource
      owner   => root,
      group   => root,
      mode    => '0644'
    },
    data      => {
      list    => [ 1 ],
      hash    => {
        value => 'initialised to 1'
      }
    },
  }

  collections::register_executor { 'collections::file::debug::file-test':
    target   => 'file-test',
    resource => 'collections::debug_executor'
  }

  collections::append { 'Append to the list, overwrite the hash key':
    target => 'file-test',
    data   => {
      list => [ 2 ],
      hash => {
        value => 'overwritten to 2'
      }
    },
  }

  collections::append { 'Append to the list, overwrite the hash key again':
    target => 'file-test',
    data   => {
      list => [ 3 ],
      hash => {
        value => 'finally set to 3'
      }
    },
  }
EOF
      end

      it { is_expected.to compile }

      checkpoint('file-test')

      it 'Creates a file' do
        is_expected.to contain_collections__file('/tmp/collections-file-test').with(
          name: '/tmp/collections-file-test',
          collector: 'file-test',
          template: 'collections/yaml.erb',
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
              'value' => 'initialised to 1',
            },
          }
        )
        is_expected.to contain_collections__append('Append to the list, overwrite the hash key').with(
          target: 'file-test',
          data: {
            'list' => [
              2,
            ],
            'hash' => {
              'value' => 'overwritten to 2',
            },
          }
        )
        is_expected.to contain_collections__append('Append to the list, overwrite the hash key again').with(
          target: 'file-test',
          data: {
            'list' => [
              3
            ],
            'hash' => {
              'value' => 'finally set to 3',
            },
          }
        )
        is_expected.to contain_collections__create('file-test').with(
          target: 'file-test',
          defaults: {}
        )
        is_expected.to contain_collections__register_executor('collections::file::writer::file-test').with(
          target: 'file-test',
          resource: 'collections::file::writer',
          parameters: {
            'file' => {
              'owner' => 'root',
              'group' => 'root',
              'mode' => '0644',
              'path' => '/tmp/collections-file-test',
            },
            'template' => 'collections/yaml.erb',
            'template_body' => nil,
            'merge_options' => {},
            'reverse_merge_order' => false,
          }
        )
        is_expected.to contain_collections__register_executor('collections::file::debug::file-test').with(
          name: 'collections::file::debug::file-test',
          target: 'file-test',
          resource: 'collections::debug_executor'
        )
        is_expected.to contain_collections__iterator('file-test')
        is_expected.to contain_collections__commit('file-test').with(
          items: [
            {
              'list' => [1],
              'hash' => { 'value' => 'initialised to 1' }
            },
            {
              'list' => [2],
              'hash' => { 'value' => 'overwritten to 2' }
            },
            {
              'list' => [3],
              'hash' => { 'value' => 'finally set to 3' }
            }
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
                'template' => 'collections/yaml.erb',
                'template_body' => nil,
                'merge_options' => {},
                'reverse_merge_order' => false,
              },
            },
          ]
        )
        is_expected.to contain_collections__file__writer('file-test::executor::2').with(
          target: 'file-test',
          items: [
            {
              'list' => [1],
              'hash' => { 'value' => 'initialised to 1' }
            },
            {
              'list' => [2],
              'hash' => { 'value' => 'overwritten to 2' }
            },
            {
              'list' => [3],
              'hash' => { 'value' => 'finally set to 3' }
            }
          ],
          'file' => {
            'owner' => 'root',
            'group' => 'root',
            'mode' => '0644',
            'path' => '/tmp/collections-file-test',
          },
          'template' => 'collections/yaml.erb',
          'template_body' => nil
        )
        is_expected.to contain_collections__debug_executor('file-test::executor::1').with(
          target: 'file-test',
          items: [
            {
              'list' => [1],
              'hash' => { 'value' => 'initialised to 1' }
            },
            {
              'list' => [2],
              'hash' => { 'value' => 'overwritten to 2' }
            },
            {
              'list' => [3],
              'hash' => { 'value' => 'finally set to 3' }
            }
          ]
        )
        is_expected.to contain_notify('Collection file-test:').with(
          message: {
            'items' => [
              {
                'list' => [1],
                'hash' => { 'value' => 'initialised to 1' }
              },
              {
                'list' => [2],
                'hash' => { 'value' => 'overwritten to 2' }
              },
              {
                'list' => [3],
                'hash' => { 'value' => 'finally set to 3' }
              }
            ],
          }
        )

        is_expected.to contain_file('/tmp/collections-file-test').with(
          path: '/tmp/collections-file-test',
          owner: 'root',
          group: 'root',
          mode: '0644',
          content: "---\nlist:\n- 1\n- 2\n- 3\nhash:\n  value: finally set to 3\n"
        )

        is_expected.to contain_collections__create('foo').with(
          target: 'foo',
          defaults: {}
        )
        is_expected.to contain_collections__register_executor('collections::file::writer::foo').with(
          target: 'foo',
          resource: 'collections::file::writer',
          parameters: {
            'file' => {
              'path' => '/foo/bar',
            },
            'template' => 'collections/yaml.erb',
            'template_body' => nil,
            'merge_options' => {},
            'reverse_merge_order' => false,
          }
        )
        is_expected.to contain_collections__iterator('foo')
        is_expected.to contain_collections__commit('foo').with(
          items: [],
          actions: [],
          executors: [
            {
              'resource' => 'collections::file::writer',
              'parameters' => {
                'file' => {
                  'path' => '/foo/bar',
                },
                'template' => 'collections/yaml.erb',
                'template_body' => nil,
                'merge_options' => {},
                'reverse_merge_order' => false,
              },
            },
          ]
        )
        is_expected.to contain_collections__file__writer('foo::executor::1').with(
          target: 'foo',
          items: [],
          'file' => {
            'path' => '/foo/bar',
          },
          'template' => 'collections/yaml.erb',
          'template_body' => nil,
          'merge_options' => {},
          'reverse_merge_order' => false
        )

        is_expected.to contain_file('/foo/bar').with(
          path: '/foo/bar',
          content: "--- \n"
        )
      end

      context 'The yaml built-in template works' do
        let(:pre_condition) do
          %(
            collections::file { '/tmp/yaml-test':
              collector     => 'yaml-test',
              template      => 'collections/yaml.erb',
            }
            [ 3, 1, 4, 2 ].each |$num| {
              collections::append { "Add ${num}":
                target => 'yaml-test',
                data   => {
                  $num => "Value ${num}"
                }
              }
            }
          )
        end

        basic_structure('yaml-test')
        it 'Generates the file' do
          is_expected.to contain_file('/tmp/yaml-test').with_content("---\n3: Value 3\n1: Value 1\n4: Value 4\n2: Value 2\n")
        end
      end

      context 'The json built-in template works' do
        let(:pre_condition) do
          %(
            collections::file { '/tmp/json-test':
              collector     => 'json-test',
              template      => 'collections/json.erb',
            }
            [ 3, 1, 4, 2 ].each |$num| {
              collections::append { "Add ${num}":
                target => 'json-test',
                data   => {
                  $num => "Value ${num}"
                }
              }
            }
          )
        end

        basic_structure('json-test')
        it 'Generates the file' do
          is_expected.to contain_file('/tmp/json-test').with_content("{\"3\":\"Value 3\",\"1\":\"Value 1\",\"4\":\"Value 4\",\"2\":\"Value 2\"}\n")
        end
      end

      context 'The concat built-in template works' do
        let(:pre_condition) do
          %(
            collections::file { '/tmp/concat-test':
              collector     => 'concat-test',
              template      => 'collections/concat.erb',
            }
            [ 3, 1, 4, 2 ].each |$num| {
              collections::append { "Add ${num}":
                target => 'concat-test',
                data   => {
                  order   => $num,
                  content => "line ${num}"
                }
              }
            }
          )
        end

        basic_structure('concat-test')
        it 'Generates the file' do
          is_expected.to contain_file('/tmp/concat-test').with(
            content: "line 1\nline 2\nline 3\nline 4\n"
          )
        end
      end

      context 'Passing a template_body works' do
        let(:pre_condition) do
          %{
            collections::file { '/tmp/template-body-test':
              collector     => 'template-body',
              template_body => "# Header\n<%= require 'yaml'; YAML.dump(@data) %>",
            }
            [1, 2, 3, 4].each |$num| {
              collections::append { "Add ${num}":
                target => 'template-body',
                data   => { list => [$num] }
              }
            }
          }
        end

        basic_structure('template-body')

        it 'Generates the file' do
          is_expected.to contain_file('/tmp/template-body-test').with(
            content: "# Header\n---\nlist:\n- 1\n- 2\n- 3\n- 4\n"
          )
        end
      end

      context 'false can overwrite true' do
        let(:pre_condition) do
          %(
            collections::file { '/tmp/boolean-test':
              collector => 'boolean-test',
              template  => 'collections/yaml.erb',
              data      => {
                enabled => true
              }
            }
            collections::append { 'Disable the key':
              target => 'boolean-test',
              data   => {
                enabled => false
              }
            }
          )
        end

        basic_structure('boolean-test')
        it 'Sets enabled to false' do
          is_expected.to contain_file('/tmp/boolean-test').with(
            content: "---\nenabled: false\n"
          )
        end
      end
    end
  end
end
