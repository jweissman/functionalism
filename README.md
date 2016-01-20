# functionalism

* [Email](mailto:jweissman1986 at gmail.com)

[![Code Climate GPA](https://codeclimate.com/github/jweissman/functionalism/badges/gpa.svg)](https://codeclimate.com/github/jweissman/functionalism)
[![Codeship Status for jweissman/functionalism](https://www.codeship.io/projects/474f9250-a1e3-0133-d683-3e2bccdc3ee6/status)](https://codeship.com/projects/128700)


## Description

Provides for symbol and proc-based functional composition with `|`.

## Features

  - Give procs superpowers, like composition of procs (and symbols, see below) with `.compose` (aliased to `|`)
  - Other things like symbols get some powers too, like curried procs from symbols with `:join.(' ')`

## Augmentations

Here are some of the super-powers `Proc` and friends will have after including this.

### Proc

  - Compose procs with `|` (this is chainable, chaining is associative)
  - Compose a proc with itself 'n' times with ^: `any_proc ^ n # any_proc | any_proc | any_proc ...`
  - Arithmetic sum, product and exponents of a proc with `+`, `*` and `**`
  - Memoize a proc with `~`
  - Apply a proc to every element of an array with `%`
  - Negate a proc with unary `-`

### Symbol

  - Automatic `#to_proc` conversion in a compositional pipeline: `:upcase | :reverse`
  - Curry with `#call` like `:split.(' ')` (courtesy of [this approach from StackOverflow](http://stackoverflow.com/questions/23695653/can-you-supply-arguments-to-the-mapmethod-syntax-in-ruby))
  - `#each` to map the `proc`-ified symbol: `:split.(' ') | :capitalize.each | :reverse`
  - `#elements` for a proc to call a message once for *each* argument

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
