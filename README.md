# collections

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with collections](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
  1. [A simple example](#a-simple-example)
  1. [Creating a file](#creating-a-file)
    1. [Concat](#concat)
    1. [YAML](#yaml)
    1. [JSON](#json)
  1. [Testing](#testing)
  1. [How collections works](#how-collections-works)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Collections is a generic iterator written in (nearly) pure puppet. You can
declare an iterator stack, add items to the stack as you process, then define
a set of actions that will be called with those items. Some examples from my
own codebase using it are:

* Build a file with multiple modules contributing fragments, and be able to
  write a simple test for the contents of it. This functionality owes a debt
  to richardc's `datacat` module, but is hopefully much easier to work with.

* Declare a collection for 'all users' and 'admin users'. You're now able to
  have a module declare 'Okay, create a resource of this type for every user'

* In combination with a fact listing 'extra' IPs per instance, remove any IPs
  that aren't defined in the current puppet run cleanly.

## Setup

Collections uses the Ruby `deep_merge` gem which can recursively merge both
hashes and arrays.

## Usage

### A simple example

Here's an example of how you could use Collections to allow modules to easily
define additional functionality for admin users:

First, in a module handling your users, create some collections:
```puppet
  # During initialisation
  collections::create { 'all-users': }
  collections::create { 'admin-users': }
```

Then in a class that handles creation of users:
```puppet
  $configured_users.each |$name, $user| {
    # ... Configure the user

    collections::append { "user ${name}":
      target => 'all-users',
      data   => {
        $name => $user,
      },
    }

    if $is_admin_user {
      collections::append { "${name} is an admin":
        target => 'admin-users',
        data   => {
          $name => $user,
        },
      }
    }
  }
```

You can now add dependent resources to the collections. For example, if you
install a database server, you might want every admin user to have access to
the database.

In your database configuration module, you can now define a type to give admin
access:
```puppet
define database::admin_user (
  String[1] $target, # The name of the collection (in case of reuse)
  Any $item, # The item passed in. In this example a hash: { $name => $user }
) {
  # ... configure this user as an admin
}
```

And add the following to the class that installs the database server:
```puppet
  collections::register_action { 'Admin users get database access':
    target   => 'admin-users',
    resource => 'database::admin_user',
  }
```

### Creating a file

A common use case is to allow multiple actors to contribute to a file. A small
suite of convenience functions have been added to Collections for this use
case. These are built on top of `collections::create`, `collections::append`,
and so on.

To create a file, first declare it with `collections::file`. The following
example uses the built-in YAML template, which will take all the items in
the collection, merge them in order and write the result to the file as
YAML:
```puppet
  collections::file { '/path/to/file.yaml':
    collector => 'app-config-file',
    template  => 'collections/yaml.erb',
    file      => {
      owner => 'root',
      group => 'root',
      mode  => '0640',
    },
    data      => {
      config => {
        user => 'nobody',
      },
    },
  }
```
(`data` passed above is optional, a first item for the collection).

You can then add data to the file using collections::append:
```puppet
  collections::append { 'App: Set chroot options':
    target => 'app-config-file',
    data   => {
      config => {
        use_chroot => true,
        chroot_dir => '/var/spool/app/chroot',
      },
    },
  }
```

#### Concat
Template name: `collections/concat.erb`

This allows for joining individual content blocks together, with some inbuilt
ordering. It expects the `data` key to be a hash containing two items:
* `order` - An Integer used as a primary sort key for the items. Default: 1000
* `content` - A string to write to the file.

Sorting is by the `order` key first, then by definition order. You can omit
the `order` key entirely if you wish to use only Puppet's resource ordering.

Example:
```puppet
collections::append { 'Append to a concat file':
  target => 'a-collection-using-the-concat-template',
  data   => {
    order   => 100,
    content => 'Some string content for the file',
  },
}
```

#### YAML
Template name: `collections/yaml.erb`

Takes any sequence of `data` items and sequentially merges them together with
`deep_merge`, then converts the result to YAML and writes it to a file.

#### JSON
Template name: `collections/json.erb`

Takes any sequence of `data` items and sequentially merges them together with
`deep_merge`, then converts the result to JSON and writes it to a file.

### Testing

One of the core design goals for this module was to be able to have distributed
actions without impacting the ability to test. Because the core 'engine' in the
module is standard Puppet resource execution and ordering, there are no special
tricks or techniques. If you use `collection::file` to create a file, you can
then test for a `file` resource with the expected `content` field, just as if
you created it directly.

### How collections works

The core mechanic that allows collections to work is declaring resources with
the correct structure and initial data, then appending to them using resource
references. This is quite tricky to get right, and while the actual code in
collections is quite small, the structure is vital.

#### Order of processing

Within a collection, the order of processing is:

* Gather items
* Run all executors (resources that are instantiated with the complete list
  of items as a single parameter)
* Run all actions (resources that are instantiated once for each item)
* Complete

If you ever need to take particular actions at specific times within this
processing, you can add constraints on `Collections::Checkpoint` resources:

* `Collections::Checkpoint["collection::${name}::before-executors"]
* `Collections::Checkpoint["collection::${name}::after-executors"]
* `Collections::Checkpoint["collection::${name}::before-actions"]
* `Collections::Checkpoint["collection::${name}::after-actions"]
* `Collections::Checkpoint["collection::${name}::completed"]

#### A simplified explanation

To simplify the explanation, we will only cover how items are added to the
collection and processed by it.

To create a collection you define a `collection::create` resource:
```puppet
collections::create { 'example': }
```

This results in the following chain of resources and constraints:
```puppet

# Created by the user
collections::create { 'example': }

# Created by collections::create
collections::iterator { 'example':
  items => []
}
Collections::Append <|target == 'example'|> -> Collections::Commit['example']

# Created by collections::iterator
collections::iterator { 'example':
  items => []
}
```

When `collections::append` is used to add an item, it runs the following:
```puppet
Collections::Commit <|title=='example'|> {
  items +> [ $new_item ]
}
```

This is a deeper structure than may be expected, but it is required to
function - in particular, the resource constraint that declares all
appends must complete before the commit only works when it is outside
the commit resource.

## Limitations


## Development


