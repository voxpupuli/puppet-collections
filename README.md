# collections

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with collections](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
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

There should not be much setup required. 

## Usage

Creating a file with


## Limitations

In the Limitations section, list any incompatibilities, known issues, or other
warnings.

## Development

In the Development section, tell other users the ground rules for contributing
to your project and how they should submit their work.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You can also add any additional sections you feel are
necessary or important to include here. Please use the `##` header.

[1]: https://puppet.com/docs/pdk/latest/pdk_generating_modules.html
[2]: https://puppet.com/docs/puppet/latest/puppet_strings.html
[3]: https://puppet.com/docs/puppet/latest/puppet_strings_style.html
