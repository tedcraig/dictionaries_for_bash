# Dictionaries for Bash

## Description

Provides hacky, dictionary-like data "object" for bash v3 (or other bash versions that do not support associative arrays).

filename: dictionaries_for_bash
author: Ted Craig

## Dev Notes

Developed and tested on MacOs Ventura using bash v3.2.57(1)-release. Not extensively tested elsewhere.

## Usage

```Dictionary::create <dictionary_name> [<KEY>=<VALUE> [...]]```
create dictionary with specified name:

```<dictionary_name>::add <KEY>=<VALUE> [...]```
add key/value pair(s) to dictionary

```<dictionary_name>::get <KEY>```
get value for specified key - result is echoed
  ```my_val=$(<dictionary_name>::get <KEY>)```

```<dictionary_name>::delete <KEY>```
delete key/value pair

```<dictionary_name>::list```
print list of key/value pairs - formatted: dictionary_name: key1=val1 key2=val2

```<dictionary_name>::list_resources```
prinst list of all dictionary-related set variables and functions for the specified dictionary -
result is printed on serveral lines, one per resource