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
# erl-opts: Opts interface for the Utility functions written for the Easy Relative Linking tool.


# get script source
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"


# source shared functions
source "${SOURCE_DIR}/utils.sh"


# ================= DO NOT EDIT BEYOND THIS LINE =================

# get arguments
while [[ ${#} -gt 0 ]]; do
    case "${1}" in
        -h|--help)
            help
            status="${?}"
            shift
            ;;
        --get-realpath-cmd)
            get_realpath_cmd "${@:2}"
            status="${?}"
            shift
            ;;
        --resolve-path)
            resolve_path "${@:2}"
            status="${?}"
            shift
            ;;
        --get-relative-path)
            get_relative_path "${@:2}"
            status="${?}"
            shift
            ;;
        --link-relative-path)
            link_relative_path "${@:2}"
            status="${?}"
            shift
            ;;
        --get-user-path)
            get_user_path "${@:2}"
            status="${?}"
            shift
            ;;
        --get-source-paths)
            get_source_paths "${@:2}"
            status="${?}"
            shift
            ;;
        --find-links)
            find_links "${@:2}"
            status="${?}"
            shift
            ;;
        --absolute-to-relative)
            absolute_to_relative "${@:2}"
            status="${?}"
            shift
            ;;
    esac
    shift
done

exit ${status}
