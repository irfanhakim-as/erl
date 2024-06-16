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


# get realpath command
function get_realpath_cmd() {
    # determine realpath command
    REALPATH_CMD="realpath"
    # WARNING: does not work on macOS without coreutils!
    if [ -x "$(command -v grealpath)" ]; then
        REALPATH_CMD="grealpath"
    fi
    echo "${REALPATH_CMD}"
}


# resolve provided path
function resolve_path() {
    # local path="${1/#\~/${HOME}}"
    local path="${1}"
    # REALPATH_CMD=$(get_realpath_cmd)
    # echo "$(${REALPATH_CMD} -s "${path}")"
    echo "$(python -c "import os.path; print(os.path.abspath(os.path.expanduser(\"${path}\"))) if \"${path}\" else exit()" 2>/dev/null)"
}


# get relative path between two absolute (destination, source) paths
function get_relative_path() {
    local destination=$(resolve_path "${1}")
    local source=$(resolve_path "${2}")
    # if the destination is not a dir, get the parent dir otherwise the relative path will be one level deeper
    if [[ ! -d "${1}" ]]; then
        destination=$(dirname "${destination}")
    fi
    # return relative path only if both destination and source exist
    if [[ -e "${destination}" ]] && [[ -e "${source}" ]]; then
        # REALPATH_CMD=$(get_realpath_cmd)
        # echo $(${REALPATH_CMD} -s --relative-to="${destination}" "${source}" 2>/dev/null)
        echo "$(python -c "import os.path; print(os.path.relpath(\"${source}\", \"${destination}\"))" 2>/dev/null)"
    fi
}


# link source path (relatively) to destination path
function link_relative_path() (
    local source_path=$(resolve_path "${1}")
    local destination_path=$(resolve_path "${2}")

    # get relative path between destination and source
    relative_path=$(get_relative_path "${destination_path}" "${source_path}")

    # if relative path isn't empty
    if [[ -n "${relative_path}" ]]; then
        # link source relative to destination
        echo "Linking \"${relative_path}\" -> \"${destination_path}\""
        ln -sf "${relative_path}" "${destination_path}"
    fi
)


# get user provided path
function get_user_path() {
    local path
    local help_message="${1:-"path"}"
    while [ -z "${path}" ]; do
        read -p "Enter ${help_message}: " path
        # resolve provided path
        path=$(resolve_path "${path}")
    done
    echo "${path}"
}


# get array of user provided paths
function get_user_paths() {
    local paths=()
    local help_message="${1:-"path"}"
    while true; do
        read -p "Enter ${help_message}: " path
        if [[ -z "${path}" ]]; then
            break
        fi
        path=$(resolve_path "${path}")
        # add to array if path value is not empty
        if [[ -n "${path}" ]]; then
            paths+=("${path}")
        fi
    done
    echo "${paths[@]}"
}


# find links from a provided path
function get_links() {
    local -n links=${1}
    local path="${2}"
    # resolve provided path
    path=$(resolve_path "${path}")
    # check if provided path exists
    if [[ -e "${path}" ]]; then
        # check if symlink if the provided path is a file
        if [[ -f "${path}" ]] && [[ -L "${path}" ]]; then
            link_file="${path}"
            target_file=$(readlink -f "${link_file}")
            # add to associative array
            links["${link_file}"]="${target_file}"
        # iterate through directory and add links to array
        elif [[ -d "${path}" ]]; then
            # iterate through all files in the directory
            for file in "${path}"/*; do
                # check if file is a symlink
                if [[ -L "${file}" ]]; then
                    link_file="${file}"
                    target_file=$(readlink -f "${link_file}")
                    # add to associative array
                    links["${link_file}"]="${target_file}"
                fi
            done
        fi
    fi
}


# update symlink to relative link
function absolute_to_relative() {
    # get link path
    for symlink_path in "${@}"; do
        # check if link path is provided
        if [[ -n "${symlink_path}" ]]; then
            # resolve link path
            symlink_path=$(resolve_path "${symlink_path}")
            # check if provided path is a symlink
            if [[ -L "${symlink_path}" ]]; then
                # get target path
                local target_path=$(readlink -f "${symlink_path}")
                # link relatively if target path exists
                if [[ -e "${target_path}" ]]; then
                    # if link path is an existing directory, remove it first to replace it
                    if [[ -d "${symlink_path}" ]]; then
                        rm -rf "${symlink_path}"
                    fi
                    link_relative_path "${target_path}" "${symlink_path}"
                fi
            fi
        fi
    done
}
