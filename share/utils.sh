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
# erl-utils: Utility functions written for the Easy Relative Linking tool.


# constants
APP_NAMESPACE="erl"


# print help message
function print_help() {
    echo "Usage: ${0} [OPTIONS]"; echo
    echo "OPTIONS:"
    echo "  --resolve-path <path>                                       Resolve the provided path fully."
    echo "  --get-relative-path <destination-path> <source-path>        Get the relative path between two paths."
    echo "  --link-path <source-path> <destination-path>                Create (relative) link between two paths."
    echo "  --get-destination                                           Get the intended destination path."
    echo "  --get-source-paths                                          Get the source paths to link."
    echo "  -h, --help                                                  Show this help message."; echo
    echo "Report bugs to https://github.com/irfanhakim-as/${APP_NAMESPACE}/issues"
}


# resolve provided path
function resolve_path() {
    local path="${1}"
    echo $(eval "echo ${path}")
}


# get relative path between two absolute (destination, source) paths
function get_relative_path() {
    # if the destination path does not exist, assume it's a file and that the parent directory exists
    if [[ ! -e "${1}" ]]; then
        destination=$(dirname "${1}")
    else
        destination="${1}"
    fi
    source="${2}"
    # determine realpath command
    REALPATH_CMD="realpath"
    # WARNING: does not work on macOS without coreutils!
    if [ -x "$(command -v grealpath)" ]; then
        REALPATH_CMD="grealpath"
    fi
    echo $(${REALPATH_CMD} --relative-to="${destination}" "${source}" 2>/dev/null)
}


# link source path (relatively if possible) to absolute (destination) path
function link_path() (
    local source_path="${1}"
    local destination_path="${2}"

    # get relative path between destination and source
    if [[ -e "${source_path}" ]]; then
        relative_path=$(get_relative_path "${destination_path}" "${source_path}")
    fi

    # if relative path isn't empty
    if [[ -n "${relative_path}" ]]; then
        # link source relative to destination
        echo "Linking \"${relative_path}\" -> \"${destination_path}\""
        ln -sf "${relative_path}" "${destination_path}"
    fi
)


# get destination absolute path
function get_destination() {
    local destination_path
    while [ -z "${destination_path}" ]; do
        read -p "Enter destination path: " destination_path
        # resolve destination path
        destination_path=$(resolve_path "${destination_path}")
    done
    echo "${destination_path}"
}


# loop get input as source path, end loop if empty, return all the inputs as an array
function get_source_paths() {
    local -n paths=${1}
    while true; do
        read -p "Enter source path: " source_path
        if [[ -z "${source_path}" ]]; then
            break
        fi
        source_path=$(resolve_path "${source_path}")
        # add to array if source path value is not empty and it exists
        if [[ -n "${source_path}" ]] && [[ -e "${source_path}" ]]; then
            paths+=("${source_path}")
        fi
    done
}
