# Exam-Kit

## Description

This collection of software, written in Perl, is intended to span
"different" exams from a sample file, tyipically typed using the LaTeX
system and a document class published here.

## What does it do, exactly?

There will be three executables: test_span, loa and grade, each one doing the following:

* test_span: receives a LaTeX file, using an appropriate document class,
  with many enumerate-like enviroment instances, named "question", each
  one with one sub-environment (also enumerate-like) named
  "alternatives". Each "alternatives" instance has only one item tagged
  with some specific string poiting that this is the correct answer.

  With this input, test_spam creates another LateX file with a
  permutation of question environments, and on each of them, a
  permutation of its alternatives environment.

* loa: list of answers. Given a LaTeX file created by test_span, loa
  reads it and create a text file containing a raw list of correct
  answers to that version of the test.

* grade: reads a file with the identification of students, its test
  version and its answers comparing that answers to the correct ones
  given by loa.
