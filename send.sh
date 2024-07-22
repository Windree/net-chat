#!/usr/bin/env bash
set -Eeuo pipefail

function main() {
    local error=0
    while [ $# -gt 0 ]; do
        if ! send "$1"; then
            error=1
        fi
        shift
    done
    exit $error
}

function send() {
    if [[ $1 =~ ^(tcp|udp)([46]*)://([^:]+):([[:digit:]]+)$ ]]; then
        proto=${BASH_REMATCH[1]}
        ipv=${BASH_REMATCH[2]:-4}
        host=${BASH_REMATCH[3]}
        port=${BASH_REMATCH[4]}
    else
        echo "Incorrect address: $1"
        echo "Correct is tcp://host:999 or udp://host:999"
        exit 1
    fi

    declare -a arguments=(-q1)
    if [ -n "$ipv" ]; then
        arguments+=(-$ipv)
    fi
    if [ $proto == udp ]; then
        arguments+=(-u)
    fi

    nc "${arguments[@]}" $host $port 2>/dev/null
}

function check_requirements() {
    if ! which nc >/dev/null; then
        echo "nc (netcat) is not installed. Skipping"
        exit 255
    fi
}

check_requirements

main "$@"
