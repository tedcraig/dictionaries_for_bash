#! /usr/bin/env bash

## import "hashmap" functionality
source ./Hashmap.sh

## create a hashmap without setting any initial values
echo "create hashmap hmOne"
create_hashmap hmOne

echo
echo "adding age and name to hmOne"
hmOne::add age=48
hmOne::add name=djthadius

echo
echo "get..."
echo "assign to age"
age=$(hmOne::get age)
echo "age: $age"
echo "assign to name"
name=$(hmOne::get name)
echo "name: $name"
arr=($(other_func))
echo "arr length: ${#arr[@]}"
echo "arr: ${arr[@]}"
echo
echo "listing pairs..."
hmOne::list
echo
echo "deleting name ..."
hmOne::delete "name"
echo
echo "listing pairs..."
hmOne::list
echo
echo
echo "hashmap two ..."
create_hashmap hmTwo name=Ted age=old
echo
hmTwo::get age
hmTwo::get name
echo
age=$(hmTwo::get age)
echo "age: $age"
name=$(hmTwo::get name)
echo "name: $name"
echo "listing pairs..."
hmTwo::list
echo
echo
echo "function list:"
compgen -A function
echo
echo "hmOne variable list:"
compgen -A variable hmOne_
echo
echo "hmTwo variable list:"
compgen -A variable hmTwo_