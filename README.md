# Exam-Kit

## Description

This collection of software, written in Perl, is intended to span
"different" exams from a sample file, tyipically typed using the LaTeX
system and a document class published here.

## What does it do, exactly?

There will be three executables: `test_span`, `loa` and `grade`, each
one doing the following:

* `test_span`: receives a LaTeX file, using an appropriate document class,
  with many enumerate-like enviroment instances, named "question", each
  one with one sub-environment (also enumerate-like) named
  "alternatives". Each "alternatives" instance has only one item tagged
  with some specific string poiting that this is the correct answer.

  With this input, test_spam creates another LateX file with a
  permutation of question environments, and on each of them, a
  permutation of its alternatives environment.

* `loa`: list of answers. Given a LaTeX file created by test_span, loa
  reads it and create a text file containing a raw list of correct
  answers to that version of the test.

* `grade`: reads a file with the identification of students, its test
  version and its answers comparing that answers to the correct ones
  given by loa.

## Licensing

`Exam-Kit` is free software: you can redistribute it and/or modify it
under the terms of the [GNU General Public License][0] as published by the
[Free Software Foundation][1], either version 3 of the License, or (at your
option) any later version.

Exam-Kit is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the [GNU General Public License][0]
for more details.

[0]: http://www.gnu.org/licenses/gpl-3.0-standalone.html
[1]: http://fsf.org/