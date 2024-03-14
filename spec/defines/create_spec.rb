# frozen_string_literal: true

require 'spec_helper'

describe 'collections::create' do
  let(:title) { 'namevar' }
  let(:params) do
    {}
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:pre_condition) do
        <<EOF
  # Define an iterator stack
  collections::create { 'foo':
  }

  # Add a thing for the stack to do:
  # collections::tap is a defined type that will create a notify resource containing its parameters
  collections::register_action { 'Test: Add a define':
    target   => 'foo',
    resource => 'collections::tap',
    wrapped  => true,
  }
  
  # Register a defined type that will process all of the collected items, rather than being called
  # once per item. As with actions, multiple executors may be defined
  collections::register_executor { 'Test: Add an executor':
    target   => 'foo',
    resource => 'collections::debug_executor',
    context  => {}
  }

  # Send four items through the stack
  # In this case, it will create a 'collections::tap' for each one
  [1, 2, 3, 4].each |$num| {
    collections::append { "Add item ${num} to foo":
      target => 'foo',
      item   => $num,
    }
  }
EOF
      end

      it { is_expected.to compile }

      it 'Creates an iterator' do
        is_expected.to contain_collections__create('foo').with(
          name: 'foo',
          target: 'foo',
          defaults: {},
        )

        is_expected.to contain_collections__register_action('Test: Add a define').with(
          name: 'Test: Add a define',
          target: 'foo',
          resource: 'collections::tap',
          wrapped: true,
        )

        is_expected.to contain_collections__register_executor('Test: Add an executor').with(
          name: 'Test: Add an executor',
          target: 'foo',
          resource: 'collections::debug_executor',
          context: {},
        )

        is_expected.to contain_collections__append('Add item 1 to foo').with(
          name: 'Add item 1 to foo',
          target: 'foo',
          item: 1,
        )

        is_expected.to contain_collections__append('Add item 2 to foo').with(
          name: 'Add item 2 to foo',
          target: 'foo',
          item: 2,
        )
        is_expected.to contain_collections__append('Add item 3 to foo').with(
          name: 'Add item 3 to foo',
          target: 'foo',
          item: 3,
        )
        is_expected.to contain_collections__append('Add item 4 to foo').with(
          name: 'Add item 4 to foo',
          target: 'foo',
          item: 4,
        )
        is_expected.to contain_collections__iterator('foo').with(
          name: 'foo',
          items: [
            1,
            2,
            3,
            4,
          ],
          resources: [
            'collections::tap',
          ],
          wrapped: [
            'collections::tap',
          ],
          executors: [
            {
              'r' => 'collections::debug_executor',
              'c' => {},
            },
          ],
          defaults: {},
        )
        is_expected.to contain_collections__debug_executor('foo::executor').with(
          name: 'foo::executor',
          target: 'foo',
          items: [
            1,
            2,
            3,
            4,
          ],
          context: {},
        )
        is_expected.to contain_collections__tap('foo:0:0').with(
          name: 'foo:0:0',
          target: 'foo',
          item: 1,
        )
        is_expected.to contain_collections__tap('foo:0:1').with(
          name: 'foo:0:1',
          target: 'foo',
          item: 2,
        )
        is_expected.to contain_collections__tap('foo:0:2').with(
          name: 'foo:0:2',
          target: 'foo',
          item: 3,
        )
        is_expected.to contain_collections__tap('foo:0:3').with(
          name: 'foo:0:3',
          target: 'foo',
          item: 4,
        )
        is_expected.to contain_notify('Collection foo: [1, 2, 3, 4]').with(
          name: 'Collection foo: [1, 2, 3, 4]',
        )
        is_expected.to contain_notify('Collections::Tap: foo:0:0').with(
          name: 'Collections::Tap: foo:0:0',
          message: {
            'item' => 1,
          },
        )
        is_expected.to contain_notify('Collections::Tap: foo:0:1').with(
          name: 'Collections::Tap: foo:0:1',
          message: {
            'item' => 2,
          },
        )
        is_expected.to contain_notify('Collections::Tap: foo:0:2').with(
          name: 'Collections::Tap: foo:0:2',
          message: {
            'item' => 3,
          },
        )
        is_expected.to contain_notify('Collections::Tap: foo:0:3').with(
          name: 'Collections::Tap: foo:0:3',
          message: {
            'item' => 4,
          },
        )
      end
    end
  end
end
