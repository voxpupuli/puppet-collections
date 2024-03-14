# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include collections::file_test
class collections::file_test {
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

  collections::file::fragment { 'Add two':
    target => 'file-test',
    data   => {
      list => [ 2 ],
      hash => { two => 2 },
      repl => { not_two => 7 },
    },
  }

  collections::file::fragment { 'Overwrite':
    target => 'file-test',
    data   => {
      hash => { one => 3 },
      repl => { not_two => 2 },
    },
  }
}
