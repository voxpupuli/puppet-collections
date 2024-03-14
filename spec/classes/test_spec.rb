# frozen_string_literal: true

require 'spec_helper'

describe 'collections::test' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      # it { generate('Creates an iterator') }
      ### BEGIN GENERATED TESTS: Creates an iterator ###
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
          resource: 'collections::debug_list',
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
              'r' => 'collections::debug_list',
              'c' => {},
            },
          ],
          defaults: {},
        )
        is_expected.to contain_collections__debug_list('foo::executor').with(
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
      ### END GENERATED TESTS: Creates an iterator ###
    end
  end
end
