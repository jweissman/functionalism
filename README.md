# functionalism

* [Email](mailto:jweissman1986 at gmail.com)

[![Code Climate GPA](https://codeclimate.com/github/jweissman/functionalism/badges/gpa.svg)](https://codeclimate.com/github/jweissman/functionalism)

## Description

Provides for proc-based functional composition with |.

## Features

  - Compose procs with `.compose` (aliased to `|`)
  - Compose a proc with itself 'n' times with ^: `any_proc ^ n # any_proc | any_proc | any_proc ...`
  - Gives `Proc` a few arithmetic-oriented operations for good measure (+ and * for function sum and product)

## Examples

    require 'functionalism'

    inp = -> { gets }
    out = ->(x) { print x }
    cap = ->(s) { s.capitalize }

    # capture a line from stdin and print
    (inp | out).call

    # interpose a filter
    (inp | cap | out).call

## Install

  Add to the Gemfile. 
  
    gem 'functionalism', github: 'jweissman/functionalism'

## Copyright

Copyright (c) 2016 Joseph Weissman

See {file:LICENSE.txt} for details.
