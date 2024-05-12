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


# source project files
source "${SOURCE_DIR}/md.sh"
source "${SOURCE_DIR}/utils.sh"


# print help message
function help() {
    echo "Usage: ${0} [OPTIONS]"; echo
    echo "OPTIONS:"
    echo "  -h, --help                                                  Show this help message."
    echo "  --get-realpath-cmd                                          Return the system's realpath command."
    echo "  --resolve-path <path>                                       Resolve the provided path fully."
    echo "  --get-relative-path <destination-path> <source-path>        Get the relative path between two paths."
    echo "  --link-relative-path <source-path> <destination-path>       Create a relative link between two paths."
    echo "  --get-user-path                                             Get a user provided path interactively."
    echo "  --get-user-paths                                            Get an array of user provided paths interactively."
    echo "  --get-links <path>                                          Return an associative array of links found in a directory."
    echo "  --absolute-to-relative <link-paths>                         Update an existing link to a relative link."; echo
    echo "Report bugs to https://github.com/irfanhakim-as/${APP_NAMESPACE}/issues"
}


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
        --get-user-paths)
            get_user_paths "${@:2}"
            status="${?}"
            shift
            ;;
        --get-links)
            get_links "${@:2}"
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
