# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include collections::test
class collections::test {

  # Contains tests of the collections constructs

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
    resource => 'collections::debug_list',
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
}
