# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'collections::file' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<~PUPPET
        collections::file { '/tmp/collections.yaml':
          collector => 'yaml-file',
          template  => 'collections/yaml.epp',
          file      => {
            mode => '0640',
          },
          data      => {
            config => {
              user => 'nobody',
              list => [1],
            },
          },
        }

        collections::append { 'yaml: add chroot':
          target => 'yaml-file',
          data   => {
            config => {
              chroot => true,
              list   => [2],
            },
          },
        }

        collections::file { '/tmp/collections.json':
          collector => 'json-file',
          template  => 'collections/json.epp',
          data      => {
            name => 'example',
          },
        }

        collections::append { 'json: add port':
          target => 'json-file',
          data   => {
            port => 8080,
          },
        }

        collections::file { '/tmp/collections.txt':
          collector => 'concat-file',
          template  => 'collections/concat.epp',
        }

        collections::append { 'concat: second':
          target => 'concat-file',
          data   => {
            order   => 200,
            content => 'second line',
          },
        }

        collections::append { 'concat: first':
          target => 'concat-file',
          data   => {
            order   => 100,
            content => 'first line',
          },
        }
      PUPPET
    end
  end

  describe file('/tmp/collections.yaml') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 640 }

    its(:content_as_yaml) do
      is_expected.to eq('config' => { 'user' => 'nobody', 'list' => [1, 2], 'chroot' => true })
    end
  end

  describe file('/tmp/collections.json') do
    it { is_expected.to be_file }
    its(:content_as_json) { is_expected.to eq('name' => 'example', 'port' => 8080) }
  end

  describe file('/tmp/collections.txt') do
    it { is_expected.to be_file }
    its(:content) { is_expected.to match %r{\Afirst line\nsecond line\n?\z} }
  end
end
