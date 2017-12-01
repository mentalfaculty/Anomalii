# Anomalii

An exploratory Swift framework for Genetic Programming.

## What is Genetic Programming?

A branch of machine learning in which simple programs or mathematical functions compete to solve a problem, evolving along the lines of Darwinian evolution. A population of solutions can cross pollinate and mutate, and so evolve through generations to 'fitter' descendants. 

For a detailed overview, see [A Field Guide to Genetic Programming](http://www.gp-field-guide.org.uk).

## What Works?

- Simple scalar mathematical expressions, comprised of basic operators like addition and multiplication, decimal constants, and variables
- Mathematical expressions are trees of value types (structs)
- The basic elements of the Genetic Programming (GP), namely initial population generation, evolutionary operators including crossover and mutation
- Storing of populations and expressions using the Swift `Codable` protocol
- Basic unit tests
- A basic regression test showing how a function can be fitted by genetic programming

## What is Lacking

- There are few mathematical operators at this point, though they are very easy to add. Useful would be division and trigonometic functions
- The plan is to support vector expressions, and perhaps even matrices

## How to Install

Anomalii can be installed with the Swift Package Manager, or by building the framework target in Xcode.
