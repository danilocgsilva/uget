#!/bin/bash

uget () {

    if [[ -z $1 ]]; then
        echo An argument must be provided to be the target address to download.
        return 1
    fi

    which curl > /dev/null
    curl_exists=$?
    which wget > /dev/null
    wget_exists=$?

    if [[ $curl_exists = 0 ]]; then
        curl -O $1
        return 0
    elif [[ $curl_exists = 0 ]]; then
        wget $1
        return 0
    else
        echo Neither wget or curl utilities are installed in the system. The download can\'t proceed.
        return 1
    fi
}

## detect if being sourced and
## export if so else execute
## main function with args
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f term
else
  term "${@}"
fi
