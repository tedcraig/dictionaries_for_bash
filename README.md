# Dictionaries for Bash

## Description

Provides hacky, dictionary-like data "object" for bash v3 (or other bash versions that do not support associative arrays).

``┏━━━━━━━━━━━━━━━━━━━━━┯━━━━━━━━━━━━━━━━━━━━━━━┓``  
``┃ filename            │ dictionaries_for_bash ┃``  
``┠─────────────────────┼───────────────────────┨``  
``┃ author              │ Ted Craig             ┃``  
``┠─────────────────────┼───────────────────────┨``  
``┃ version             │ 1.0.0 beta            ┃``  
``┗━━━━━━━━━━━━━━━━━━━━━┷━━━━━━━━━━━━━━━━━━━━━━━┛``  

## Dev Notes

Developed and tested on MacOs Ventura using bash v3.2.57(1)-release. Not extensively tested elsewhere.

Class functionality is simulated, then built key-value pair data structure on top of it.  Note that data which would be private/encapsulated is, instead, global and public do to the nature and limitations of the Bash language.  

**Note**: When key/value pairs are "deleted" from a dictionary, the corresponding array element is **not removed**; instead, the data is set to a reserved value indicating that the data has been "deleted".  When new pairs are added, the dictionary will prioritize populating "deleted" indeces.  That said, if we have a dictionary with 20 elements, then "delete" 19 of them, the dictionary will retain the memory footprint of the 20 element array eventhough only one element is currently active.

Overall, this implementaion is not especially idiomatic for Bash and is probably normally outside of the intended use-case for the language.  However, this was built to support an even more rediculously out-of-scope project: a terminal UI framework written in Bash for use in Bash.

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