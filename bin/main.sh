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
source "${SOURCE_DIR}/../share/erl/utils.sh"
# source "${SOURCE_DIR}/../share/utils.sh"


# print help message
function help() {
    echo "Usage: ${0} [OPTIONS]"; echo
    echo "OPTIONS:"
    echo "  -c, --create                   Create relative link."
    echo "  -u, --update                   Update links to relative paths."
    echo "  -h, --help                     Show this help message."
    echo "  --utils                        Call utility functions."; echo
    echo "Report bugs to https://github.com/irfanhakim-as/${APP_NAMESPACE}/issues"
}


# create relative link
function create_relative_link() {
    # get destination path
    # destination_path=$(${SOURCE_DIR}/../share/utils.sh --get-destination)
    destination_path=$(get_user_path "destination path")
    echo "Destination path: ${destination_path}"; echo

    # get source paths as an array
    source_paths=($(get_source_paths)); echo

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
            link_relative_path "${source_path}" "${destination_path}"
        done
    fi
}


# update links to relative paths
function update_links() {
    path="${1}"

    # get path if not provided
    if [[ -z "${path}" ]]; then
        path=$(get_user_path)
    fi

    # get all symlinks in the provided directory
    declare -A symlinks
    get_links symlinks "${path}"; echo

    # get confirmation from user to proceed with updating found symlinks
    if [[ ${#symlinks[@]} -gt 0 ]]; then
        index=0
        echo "Symlinks:"
        for key in "${!symlinks[@]}"; do
            index=$((index+1))
            link_file="${key}"
            target_file="${symlinks[${key}]}"
            echo "${index}. ${link_file} -> ${target_file}"
        done
        echo; read -p "Proceed to update the links? [y/N]: " -n 1 -r
        if [[ ! ${REPLY} =~ ^[Yy]$ ]]; then
            exit 1
        fi
        echo; echo

        # link each symlink relatively
        for key in "${!symlinks[@]}"; do
            link_file="${key}"
            target_file="${symlinks[${key}]}"
            # if link file and target file exists
            if [[ -e "${link_file}" ]] && [[ -e "${target_file}" ]]; then
                link_relative_path "${target_file}" "${link_file}"
            fi
        done
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
        -u|--update)
            update_links "${@:2}"
            status="${?}"
            shift
            ;;
        -h|--help)
            help
            status="${?}"
            shift
            ;;
        --utils)
            "${SOURCE_DIR}/../share/erl/opts.sh" "${@:2}"
            status="${?}"
            shift
            ;;
    esac
    shift
done

exit ${status}
