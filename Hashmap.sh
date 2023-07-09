#! /usr/bin/env bash

# hashmap experiments
create_hashmap() {
    [[ $# -lt 1 ]] && {
        echo "$FUNCNAME requires at least one argument."
        exit 1
    }
    
    # setup infrastructure for this hashmap instance
    local this=$1
    local class="Hashmap"
    
    eval "${this}_keys=()"
    eval "${this}_values=()"
    
    for method in $(compgen -A function "${class}_")
    do
      echo "$method in loop";
      local prep="${method/#$class\_/$this::}() { ${method} ${this} "'$@'"; }"
      echo $prep
      eval $prep
    done
    
    # handle any key/value pairs passed to us
    shift # remove instance name arg
    [[ $# -lt 1 ]] && {
        # no key/value pairs, so break out of this function
        return
    }
    Hashmap_add "${this}" "$@"
}

# add key/value pairs to hashmap
Hashmap_add() {
    # echo "${FUNCNAME[0]} invoked"
    # echo "args: $@"
    local this=$1
    # handle key/value pairs passed to us
    shift # remove instance name arg
    [[ $# -lt 1 ]] && {
        # no key/value pairs, so break out of this function
        return
    }
    for kv_pair in $@; do
        local KEY=${kv_pair%=*}
        local VAL=${kv_pair#*=}
        eval 'local INDEX=${#'"$this"'_keys[@]}'

        echo "KEY: $KEY | VAL: $VAL | INDEX: $INDEX"
        
        local prep="${this}"'_keys['"${INDEX}"']="${KEY}"'
        # echo "$prep"
        eval $prep
        
        prep="${this}"'_values['"${INDEX}"']="${VAL}"'
        # echo "$prep"
        eval $prep
        
        prep="${this}"'_KEY_'"${KEY}"'='"${INDEX}"
        # echo "$prep"
        eval $prep
    done
}

Hashmap_get() {
    # echo "${FUNCNAME[0]} invoked"
    # echo "args: $@"
    local this=$1
    local KEY=$2
    local var="${this}"'_KEY_'"${KEY}"
    [[ -z  !${var} ]] && {
        echo "unable to get $this hashmap value: unknown key: $KEY"
        exit 1
    }
    local prep='local INDEX=${'"${this}_KEY_${KEY}"'}'
    # echo $prep
    eval $prep
    # echo "INDEX: ${INDEX}"
    prep='local VAL=${'"${this}"'_values['"${INDEX}"']}'
    # echo $prep
    eval $prep
    # echo "$KEY: $VAL"
    echo "${VAL}"
}

Hashmap_delete() {
    echo "${FUNCNAME[0]} invoked"
    echo "args: $@"
}

other_func() {
    # echo ${FUNCNAME[0]} invoked
    echo "one two three"
}

create_hashmap hmOne

hmOne::add age=48
hmOne::add name=djthadius
echo
echo
echo "get..."
# hmOne::get "age"
# hmOne::get "name"
age=$(hmOne::get age)
echo "age: $age"
name=$(hmOne::get name)
echo "name: $name"
arr=($(other_func))
echo "arr length: ${#arr[@]}"
echo "arr: ${arr[@]}"
echo
hmOne::delete "key"
echo
echo
echo "hashmap two ..."
create_hashmap hmTwo name=Ted age=old
echo
age=$(hmTwo::get age)
echo "age: $age"
name=$(hmTwo::get name)
echo "name: $name"

echo
echo "function list:"
compgen -A function
echo
echo "hmOne variable list:"
compgen -A variable hmOne_
echo
echo "hmTwo variable list:"
compgen -A variable hmTwo_
