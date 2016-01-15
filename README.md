# functionalism

* [Email](mailto:jweissman1986 at gmail.com)

[![Code Climate GPA](https://codeclimate.com/github/jweissman/functionalism/badges/gpa.svg)](https://codeclimate.com/github/jweissman/functionalism)

## Description

Provides for symbol and proc-based functional composition with |.

## Features

  - Compose procs and symbols with `.compose` (aliased to `|`)
  - Compose a proc with itself 'n' times with ^: `any_proc ^ n # any_proc | any_proc | any_proc ...`
  - Gives `Proc` a few arithmetic-oriented operations for good measure (+ and * for function sum and product)
  - Get curried procs from symbols with `:join.(' ')`

## Augmentations

Here is a full list of the super-powers `Proc` and friends will have after including this.

### Proc

  - Compose procs with `|` (this is chainable, chaining is associative)
  - Compose a proc with itself 'n' times with ^: `any_proc ^ n # any_proc | any_proc | any_proc ...`

### Symbol

  - Automatic `#to_proc` conversion in a compositional pipeline: `:upcase | :reverse`
  - Curry with `#call` like `:split.(' ')` (courtesy of [this approach from StackOverflow](http://stackoverflow.com/questions/23695653/can-you-supply-arguments-to-the-mapmethod-syntax-in-ruby))
  - `#each` to map the `proc`-ified symbol: `:split.(' ') | :capitalize.each | :reverse`
  - `#element` to build a proc calling the method with the args (`#elements` for a proc to call the message once for *each* argument)

## Examples

    require 'functionalism'

    inp = -> { gets }
    out = ->(x) { print x }
    cap = ->(s) { s.capitalize }

    # capture a line from stdin and print
    (inp | out).call

    # interpose a filter
    (inp | cap | out).call

    # a more complex pipeline constructed with symbols
    pipes = :split.(' ') | :capitalize.each | :reverse | :join.(' ')
    pipes.("hello world") #=> "World Hello"

## Install

  Add to the Gemfile.

    gem 'functionalism', github: 'jweissman/functionalism'

## Copyright

Copyright (c) 2016 Joseph Weissman

See {file:LICENSE.txt} for details.
