#!/data/data/com.termux/files/usr/bin/env bash
#
# termux.bootstrap.sh
#
# Automates base installation and configuration for Termux environment
#

# SET GLOBAL VARIABLES

# Log the program name
declare -r PROGNAME="$(basename $0)"

# Set exit codes
declare -r FAILURE=1
declare -r FILE_ERROR=2
declare -r DIR_ERROR=4
declare -r PERM_ERROR=8
declare -r ENV_ERROR=16

# Termux and bootstrap filepaths
declare -r ETC=${PREFIX}/etc
declare -r BIN=${HOME}/bin
declare -r ARCHIVE=${HOME}/bash
declare -r SCRIPTS=${PWD}/scripts

# Put a little color in your life
declare -r YELLOW='\033[1;33m' # Used as indicator
declare -r GREEN='\033[1;32m'  # Used as informational
declare -r RED='\033[1;31m'    # Used as error
declare -r BLANK='\033[1;00m'  # Reset prompt color

# Termux environment variables
declare -ra environ=($HOME $PREFIX $LD_LIBRARY_PATH)

# Determine which Python version is installed
# Value can be "2", "3", or "both"; "2" is the default value
# If you do not want Python, leave PYTHON_VERSION empty or as an empty quote PYTHON_VERSION=""
# Python2 is considered deprecated as of the year 2020
declare PYTHON_VERSION="3"

# Ensure LD_LIBRARY_PATH is set
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:-/data/data/com.termux/files/usr/lib}

function source_files () {
    for filename in "$@";
    do
        filepath="${PWD}/bootstrap/${filename}"

        if [[ -s "${filepath}" ]];
        then source "${filepath}"
        else
            echo -e "Error: '${filename}' is missing or corrupt.\nExiting now."
            exit $FILE_ERROR
        fi

        shift
    done
}

# Sources must be loaded in this exact order!
source_files "config.sh" "help.sh" "install.sh" "remove.sh"

cmd="$1"
action="$2"

case $cmd in
    h|help)
        echo_usage "$action"
        ;;
    b|backup)
        check_if_root
        check_environment
        backup_home_dir
        echo -e "${GREEN} * Successful backup.${BLANK}"
        ;;
    i|install)
        check_if_root
        check_environment
        install "$action"
        echo -e "${GREEN} * Successful installation.${BLANK}"
        ;;
    r|remove)
        check_if_root
        check_environment
        remove "$action"
        echo -e "${GREEN} * Successful removal.${BLANK}"
        ;;
    *)
        echo_usage_notice
        ;;
esac