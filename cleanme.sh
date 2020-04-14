#!/bin/bash
#
# @file cleanme
# @brief Cleanup the enviroment, from root folder run: ./cleanme.sh.

# Path to the project used as source, defaults to current path.
PROJECT_PATH=$(pwd)

# String indicating to clean only resources of specific types.
# The allowed values are:
# - a: Ansible resources.
# - p: Python resources.
# The full string is: ap.
TYPE=''

# Wheter to uninstall or not the following software:
# - ansible
# - python3
UNINSTALL=false

# @description Delete ansible auto-created files.
#
# @noargs.
#
# @exitcode 0 if successful.
# @exitcode 1 on failure.
function cleanup_ansible() {
    # Remove installed roles.
    rm -rf ~/.ansible/roles/* &>/dev/null
    if [[ $UNINSTALL == true ]]; then
        uninstall_ansible
        [ $? -eq 1 ] && return 1
    fi
    return 0
}

# @description Delete general auto-created files.
#
# @arg $1 string Optional project path. Default to current path.
#
# @exitcode 0 if successful.
# @exitcode 1 on failure.
function cleanup_general() {
    local project_path=$(pwd)
    [[ -d $1 ]] && project_path="$( cd "$1" ; pwd -P )"
    # Delete soft links on tests folder.
    for link_item in $(find . -type l -printf '%p\n'); do
        rm $link_item
    done

    # Delete docs/build folder if found.
    [[ -d $project_path/docs/build ]] && rm -rf $project_path/docs/build
    # Delete doc/build folder if found.
    [[ -d $project_path/doc/build ]] && rm -rf $project_path/doc/build
    # Delete temporary files.
    rm -rf /tmp/* &>/dev/null
    return 0
}

# @description Delete python auto-created files.
#
# @arg $1 string Optional project path. Default to current path.
#
# @exitcode 0 if successful.
# @exitcode 1 on failure.
function cleanup_python() {
    local project_path=$(pwd)
    [[ -d $1 ]] && project_path="$( cd "$1" ; pwd -P )"
    local python_files_regex="(\.pytest_cache|__pycache__|\.pyc|\.pyo$)"
    find $project_path | grep -E $python_files_regex &>/dev/null
    if [ $? -eq 0 ]; then
        rm -rf $(find $project_path | grep -E $python_files_regex)
    fi
    # Remove coverage report.
    rm -rf $project_path/htmlcov &>/dev/null
    rm -f $project_path/.coverage &>/dev/null
    return 0  
}

# @description Shows an error message.
#
# @arg $1 string Message to show.
#
# @exitcode 0 if successful.
# @exitcode 1 on failure.
function error_message() {
    [[ -z $1 ]] && return 0
    case $1 in
    path)
        echo "$1 is not an existent directory."
        ;;

    permissions)
        echo 'Administrative permissions are needed.'
        ;;
    esac

    return 0
}

# @description Get bash parameters.
#
# Accepts:
#
#  - *h* (help).
#  - *p* <path> (project_path).
#  - *t* <types> (only clean type).
#  - *u* (uninstall).
#
# @arg '$@' string Bash arguments.
#
# @exitcode 0 if successful.
# @exitcode 1 on failure.
function get_parameters() {
    # Obtain parameters.
    while getopts 'h;p:t:u;' opt; do
        OPTARG=$(sanitize "$OPTARG")
        case "$opt" in
            h) help && exit 0;;
            p) PROJECT_PATH="${OPTARG}";;
            t) TYPE="${OPTARG}";;
            u) UNINSTALL=true;;
        esac
    done
    return 0
}

# @description Shows help message.
#
# @noargs
#
# @exitcode 0 if successful.
# @exitcode 1 on failure.
function help() {
    echo 'Cleanup the enviroment.'
    echo 'Parameters:'
    echo '-h (help): Show this help message.'
    echo '-o <only type> (type string): Optional string containing any of the
             following characters: a, p. Each one indicating to only
             clean a specific type of resources, being a = ansible, p = python,
             for example the value "-o p" will clean python tests only.'
    echo '-p <file_path> (project path): Optional absolute file path to the
             root directory of the project to clean. if this
             parameter is not espeficied, the current path will be used.'
    echo '-u (uninstall): Uninstall the following software: ansible.'
    echo 'Example:'
    echo "./cleanme.sh -o ap -p /home/username/project -u"
    return 0
}

# @description Cleanup the enviroment.
#
# @arg $@ string Bash arguments.
#
# @exitcode 0 if successful.
# @exitcode 1 on failure.
function main() {

    get_parameters "$@"

    if ! [[ -d $PROJECT_PATH ]]; then
        error_message 'path'  
        return 1
    fi

    if [[ -z $TYPE ]] || [[ $TYPE == *'a'* ]]; then
        cleanup_ansible
    fi

    if [[ -z $TYPE ]] || [[ $TYPE == *'p'* ]]; then
        cleanup_python $PROJECT_PATH
    fi

    cleanup_general

    return 0
}

# @description Sanitize input.
#
# The applied operations are:
#
#  - Trim.
#  - Remove unnecesary slashes.
#
# @arg $1 string Text to sanitize.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout Sanitized input.
function sanitize() {
    [[ -z $1 ]] && echo '' && return 0
    local sanitized="$1"

    # Trim.
    sanitized=$(trim "$sanitized")

    # Remove double and triple slashes.
    # Extract the protocol URL part (http:// or https://) (if exists).
    protocol="$(echo $sanitized | grep :// | sed -e's,^\(.*://\).*,\1,g')"

    # Remove the protocol.
    sanitized="${sanitized/${protocol}/}"

    # Remove unnecesary slashes.
    sanitized=$(echo "$sanitized" | tr -s /)

    # Readd the protocol (if exists).
    sanitized=${protocol}${sanitized}

    echo "$sanitized" && return 0
}

# @description Trim whitespace at the beggining and end of a string.
#
# @arg $1 string Text where to apply trim.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout Trimmed input.
function trim() {

    [[ -z $1 ]] && return 1
    local trimmed="$1"

    # Strip leading spaces.
    while [[ $trimmed == ' '* ]]; do
       trimmed="${trimmed## }"
    done
    # Strip trailing spaces.
    while [[ $trimmed == *' ' ]]; do
        trimmed="${trimmed%% }"
    done

    echo "$trimmed" && return 0
}

# @description Uninstall Ansible.
#
# @noargs.
#
# @exitcode 0 if successful.
# @exitcode 1 on failure.
function uninstall_ansible() {
    python3 -m pip uninstall ansible -y &>/dev/null
    python -m pip uninstall ansible -y &>/dev/null
    sudo apt purge -y ansible
    sudo apt update
    sudo apt autoremove
    return 0
}

# Avoid running the main function if we are sourcing this file.
return 0 2>/dev/null
main "$@"
