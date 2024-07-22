#!/usr/bin/env bash
set -Eeuo pipefail

function main() {
    if [[ $1 =~ ^(tcp|udp)([46]*)://([[:digit:]]+)$ ]]; then
        proto=${BASH_REMATCH[1]}
        ipv=${BASH_REMATCH[2]:-4}
        port=${BASH_REMATCH[3]}
    else
        echo "Incorrect address: $1"
        echo "Correct is tcp://999 or udp://999"
        exit 1
    fi

    declare -a arguments=(-l -k)
    if [ -n "$ipv" ]; then
        arguments+=(-$ipv)
    fi
    if [ $proto == udp ]; then
        arguments+=(-u)
    fi

    nc "${arguments[@]}" $port
}

function check_requirements() {
    if ! which nc >/dev/null; then
        echo "nc (netcat) is not installed. Skipping"
        exit 255
    fi
}

check_requirements

main "$1"
