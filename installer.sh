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
# installer: Project installer script.


# source project metadata
source "./share/md.sh"


# print help message
function help() {
    echo "Usage: ${0} [options]"; echo
    echo "OPTIONS:"
    # echo "  -c, --config-prefix <path>        Specify a config prefix"
    echo "  -i, --install-prefix <path>       Specify an installation prefix"
    echo "  -l, --link-install                Perform a symlink installation"
    echo "  -u, --uninstall                   Uninstall application"
    echo "  -v, --version                     Return the version of the script"
    echo "  -h, --help                        Print help message"; echo
    echo "Report bugs to ${__source__}/issues"
}


# install script
function install() {
    echo "Installing ${__name__} v${__version__} to ${INSTALL_PFX}"
    # check for required files before proceeding
    for file in "${!required_files[@]}"; do
        if [[ ! -f "${file}" ]]; then
            echo "ERROR: Required file not found (${file})"
            exit 1
        fi
    done
    # create required directories
    for dir in "${required_directories[@]}"; do
        echo "Creating directory ${dir}"
        mkdir -p "${dir}"
    done
    # copy required files
    for file in "${!required_files[@]}"; do
        if [ "${LINK_INSTALL}" != 1 ] || [[ "${file}" =~ ^(config|log)/ ]]; then
            echo "Copying ${file} to ${required_files[${file}]}"
            cp -i "${file}" "${required_files[${file}]}"
        else
            echo "Symlinking ${file} to ${required_files[${file}]}"
            ln -s "$(realpath "${file}")" "${required_files[${file}]}"
        fi
    done
}


# uninstall script
function uninstall() {
    echo "Uninstalling ${__name__} from ${INSTALL_PFX}"
    # remove target locations
    for file in "${!required_files[@]}"; do
        if [[ -e "${required_files[${file}]}" ]]; then
            echo "Removing ${required_files[${file}]}"
            rm -f "${required_files[${file}]}" || rm -rf "${required_files[${file}]}"
        fi
    done
}


# ================= DO NOT EDIT BEYOND THIS LINE =================

# get optional arguments
while [[ ${#} -gt 0 ]]; do
    case "${1}" in
        # -c|--config-prefix)
        #     if [ -z "${2}" ]; then
        #         echo "ERROR: Please specify a config prefix"
        #         exit 1
        #     fi
        #     CONFIG_PFX="${2}"
        #     shift
        #     ;;
        -i|--install-prefix)
            if [ -z "${2}" ]; then
                echo "ERROR: Please specify an installation prefix"
                exit 1
            fi
            INSTALL_PFX="${2}"
            shift
            ;;
        -l|--link-install)
            LINK_INSTALL=1
            ;;
        -u|--uninstall)
            UNINSTALL_APP=1
            ;;
        -v|--version)
            echo "${__version__}"
            exit 0
            ;;
        -h|--help)
            help
            exit 0
            ;;
        *)
            echo "ERROR: Invalid argument (${1})"
            exit 1
            ;;
    esac
    shift
done


# set default prefixes
if [ -z "${CONFIG_PFX}" ]; then
    CONFIG_PFX="${HOME}/.config"
fi
CONFIG_PFX=$(realpath "${CONFIG_PFX}") || exit 1

if [ -z "${INSTALL_PFX}" ]; then
    INSTALL_PFX="${HOME}/.local"
fi
INSTALL_PFX=$(realpath "${INSTALL_PFX}") || exit 1


# associative array of required files and their target locations
declare -A required_files=(
    ["share/md.sh"]="${INSTALL_PFX}/share/${__namespace__}/"
    ["bin/main.sh"]="${INSTALL_PFX}/bin/${__name__}"
    ["share/utils.sh"]="${INSTALL_PFX}/share/${__namespace__}/"
    ["share/opts.sh"]="${INSTALL_PFX}/share/${__namespace__}/"
    # ["log/${__name__}.log"]="${INSTALL_PFX}/share/${__namespace__}/log/"
    # ["config/${__name__}.json"]="${CONFIG_PFX}/${__namespace__}/"
)


# determine required directories
declare -a required_directories=()
for dir in "${required_files[@]}"; do
    # check if directory not already in required_directories array
    if [[ ! " ${required_directories[@]} " =~ " ${dir%/*} " ]]; then
        required_directories+=("${dir%/*}")
    fi
done


# install or uninstall
if [ "${UNINSTALL_APP}" == "1" ]; then
    uninstall
else
    install
fi
