#!/bin/bash

## version
VERSION="0.0.1"

## output error to stderr
error () {
  printf >&2 "error: %s\n" "${@}"
}

## output usage
usage () {
  echo "usage: uget [url]"
}

## echoes the first number of response code
uget_helper_curl_first_number_response_code () {
    declare -a responses_codes
    IFS=$'\n'
    full_output=($(curl -IL --silent $1))
    for i in "${full_output[@]}"; do
        responses_codes+=($(echo $i | grep HTTP))
    done

    last_http=$(expr ${#responses_codes[@]} - 1)
    last_response_code=$(echo ${responses_codes[$last_http]} | cut -f2 -d' ')
    echo ${last_response_code:0:1}
}

## check the response code from url and download if success. Otherwise, return 1
uget_helper_curl_check_then_download () {
    first_number_response_code=$(uget_helper_curl_first_number_response_code $1)
    if [ $first_number_response_code = 2 ] || [ $first_number_response_code = 3 ]; then
        echo $1
        curl -O $1
        return 0
    else
        echo The provided resource \("$1"\) does not exists.
        return 1
    fi
}

# main entrance
uget () {

    if [[ -z $1 ]]; then
        echo An argument must be provided to be the target address to download.
        return 1
    fi

    which curl > /dev/null
    curl_exists=$?
    which wget > /dev/null
    wget_exists=$?

    if [[ $wget_exists = 0 ]]; then
        wget $1
    elif [[ $curl_exists = 0 ]]; then
        uget_helper_curl_check_then_download $1
    else
        echo Neither wget or curl utilities are installed in the system. The download can\'t proceed.
        return 1
    fi
}



## detect if being sourced and
## export if so else execute
## main function with args
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f uget
else
  uget "${@}"
  exit $?
fi
