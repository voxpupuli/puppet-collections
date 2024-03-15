# frozen_string_literal: true

require 'spec_helper'

describe 'collections::create' do
  let(:title) { 'create' }
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
  }

  # Register a defined type that will process all of the collected items, rather than being called
  # once per item. As with actions, multiple executors may be defined
  collections::register_executor { 'Test: Add an executor':
    target   => 'foo',
    resource => 'collections::debug_executor',
  }

  # Send four items through the stack
  # In this case, it will create a 'collections::tap' for each one
  [1, 2, 3, 4].each |$num| {
    collections::append { "Add item ${num} to foo":
      target => 'foo',
      data   => $num,
    }
  }
EOF
      end

      it { is_expected.to compile }

      it 'creates checkpoints' do
        %w{ create foo }.each do |title|
          %w{ before-executors after-executors before-actions after-actions completed }.each do |stage|
            is_expected.to contain_collections__checkpoint("collections::#{title}::#{stage}")
          end
        end
      end

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
        )

        is_expected.to contain_collections__register_executor('Test: Add an executor').with(
          name: 'Test: Add an executor',
          target: 'foo',
          resource: 'collections::debug_executor',
        )

        is_expected.to contain_collections__append('Add item 1 to foo').with(
          name: 'Add item 1 to foo',
          target: 'foo',
          data: 1,
        )

        is_expected.to contain_collections__append('Add item 2 to foo').with(
          name: 'Add item 2 to foo',
          target: 'foo',
          data: 2,
        )
        is_expected.to contain_collections__append('Add item 3 to foo').with(
          name: 'Add item 3 to foo',
          target: 'foo',
          data: 3,
        )
        is_expected.to contain_collections__append('Add item 4 to foo').with(
          name: 'Add item 4 to foo',
          target: 'foo',
          data: 4,
        )
        is_expected.to contain_collections__iterator('foo').with(
          name: 'foo',
          items: [
            1,
            2,
            3,
            4,
          ],
          actions: [
            {
              'resource' => 'collections::tap',
              'parameters' => {},
            },
          ],
          executors: [
            {
              'resource' => 'collections::debug_executor',
              'parameters' => {},
            },
          ],
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
        )
        is_expected.to contain_collections__tap('foo::1').with(
          target: 'foo',
          item: 1,
        )
        is_expected.to contain_collections__tap('foo::2').with(
          target: 'foo',
          item: 2,
        )
        is_expected.to contain_collections__tap('foo::3').with(
          target: 'foo',
          item: 3,
        )
        is_expected.to contain_collections__tap('foo::4').with(
          target: 'foo',
          item: 4,
        )
        is_expected.to contain_notify('Collection foo:').with(
          message: { 'items' => [1, 2, 3, 4] },
        )
        is_expected.to contain_notify('Collections::Tap: foo::1').with(
          message: {
            'item' => 1,
          },
        )
        is_expected.to contain_notify('Collections::Tap: foo::2').with(
          message: {
            'item' => 2,
          },
        )
        is_expected.to contain_notify('Collections::Tap: foo::3').with(
          message: {
            'item' => 3,
          },
        )
        is_expected.to contain_notify('Collections::Tap: foo::4').with(
          message: {
            'item' => 4,
          },
        )
      end
    end
  end
end
