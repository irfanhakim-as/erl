#!/usr/bin/env bash
#
#         :::   :::  ::::::::::::::    :::    :::
#       :+:+: :+:+:     :+:    :+:   :+:   :+: :+:
#     +:+ +:+:+ +:+    +:+    +:+  +:+   +:+   +:+  Irfan Hakim (MIKA)
#    +#+  +:+  +#+    +#+    +#++:++   +#++:++#++:  https://sakurajima.social/@irfan
#   +#+       +#+    +#+    +#+  +#+  +#+     +#+   https://github.com/irfanhakim-as
#  #+#       #+#    #+#    #+#   #+# #+#     #+#    https://gitlab.com/irfanhakim
# ###       #################    ######     ###
#
# erl: Easy Relative Linking tool written in Bash.


# constants
APP_NAMESPACE="erl"


# get script source
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# source shared functions
source "${SOURCE_DIR}/../share/utils.sh"


# print help message
function print_help() {
    echo "Usage: ${0} [OPTIONS]"; echo
    echo "OPTIONS:"
    echo "  -c, --create            Create relative link."
    echo "  -h, --help              Show this help message."; echo
    echo "Report bugs to https://github.com/irfanhakim-as/${APP_NAMESPACE}/issues"
}


# create relative link
function create_relative_link() {
    # get destination path
    # destination_path=$(${SOURCE_DIR}/../share/utils.sh --get-destination)
    destination_path=$(get_destination)
    echo "Destination path: ${destination_path}"; echo

    # get source paths
    declare -a source_paths
    # ${SOURCE_DIR}/../share/utils.sh --get-source-paths source_paths; echo
    get_source_paths source_paths; echo

    # get confirmation from user to proceed with provided source paths
    if [[ -n "${source_paths}" ]]; then
        index=0
        echo "Source paths:"
        for source_path in "${source_paths[@]}"; do
            index=$((index+1))
            echo "${index}. ${source_path}"
        done
        echo; read -p "Proceed to link them to the destination path? [y/N]: " -n 1 -r
        if [[ ! ${REPLY} =~ ^[Yy]$ ]]; then
            exit 1
        fi
        echo; echo
    fi

    # link each source path to destination path
    if [[ -n "${destination_path}" ]] && [[ -n "${source_paths}" ]]; then
        for source_path in "${source_paths[@]}"; do
            link_path "${source_path}" "${destination_path}"
        done
        # echo; echo "Done"
    fi
}


# ================= DO NOT EDIT BEYOND THIS LINE =================

# get arguments
while [[ ${#} -gt 0 ]]; do
    case "${1}" in
        -c|--create)
            create_relative_link
            status="${?}"
            shift
            ;;
        -h|--help)
            print_help
            status="${?}"
            shift
            ;;
    esac
    shift
done

exit ${status}
