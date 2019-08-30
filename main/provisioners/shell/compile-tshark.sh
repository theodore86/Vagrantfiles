#!/usr/bin/env bash
#
#Purpose: Script for compilation/decompilation of wireshark from source code.
#[Note]: Supported on Ubuntu/CentOS Linux distros

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INFO="\033[0;32m"
FAIL="\033[0;31m"
ENDC="\033[0m"
DEPS=""  #tshark dependencies
PACMAN=""  #name of the package manager

error() {

    local exit_status=85
    printf "${FAIL}ERROR>>>${ENDC} %s\n" "$(basename $0) : ${1} " 1>&2
    exit $exit_status
}

info() {

    printf "${INFO}INFO>>>${ENDC} %s\n" "$(basename $0): $1"
}

yum_s() {

    yum install -y "$@"
}

apt_s() {

    apt-get install -y "$@"
}

_pacman_detect() {

    local pacman="$1"; shift
    grep -qis "$@" /etc/issue && PACMAN="$pacman" && return
    grep -qis "$@" /etc/os-release && PACMAN="$pacman" && return
}

pacman_detect(){

   local _return=1
    _pacman_detect "yum" "CentOS" && return
    _pacman_detect "apt" "Ubuntu" && return
    return $_return
}

set_dependencies(){

      pacman_detect || error "Script doesn't support your package manager."
      local deps="automake autoconf byacc flex bison libtool libtool-bin"
      [[ "$PACMAN" = "apt" ]] && DEPS="$deps pkg-config libgcrypt11-dev libglib2.0-dev libpcap-dev"
      [[ "$PACMAN" = "yum" ]] && DEPS="$deps gcc gcc-c++ libpcap-devel libgcrypt-devel glib2-devel patch"
}

install_dependencies() {

    local _return=0
    set_dependencies
    ${PACMAN}_s $DEPS || { local _return=1; }
    return $_return
}

get_extracted_dir_name(){

    local tarball=$1
    echo $(tar -tzf $tarball | head -1 | cut -f1 -d"/") \
        || error "Fail to get extracted directory name from $tarball"
}

source_code_exists() {

    local _return=0
    ! [[ -f ${SOUCE_CODE_FP} && -d ${SOURCE_CODE_FP} ]] || { local _return=1; }
    return $_return
}

extract_tarball() {

    #return != 0 false
    local tarball=$1
    local destination=${2:-./}
    local options="$tarball -C ${destination}"
    case $tarball in
        *tar.gz)
            tar -xzf $options
            ;;
        *tar.bz2)
            tar -xvjf $options
            ;;
        *tar.xz)
            tar -xJvf $options
            ;;
    esac
}

get_tshark_folder() {

    local folder="''"
    if "$TAR"; then
        folder="${OUTPUT_DIR}/$(get_extracted_dir_name ${SOURCE_CODE_FP})"
    else
        folder="${SOURCE_CODE}"
    fi
    echo "$folder"
}

compile() {

    #compile with parameters
    local prefix="${PREFIX}"
    [[ "$*" == *prefix* ]] && { local prefix=""; }
    local parameters="$@"
    local cmd="./configure $parameters $prefix"
    $cmd
}

compile_tshark() {

    #Start the actual tshark compilation
    local tshark_folder=$(get_tshark_folder)
    if [[ "$TAR" == true ]]; then
        info "Extracting and compiling Tshark..."
        if [[ ${CURRENT_DIR} != ${OUTPUT_DIR} ]]; then
            cp -f ${SOURCE_CODE_FP} ${OUTPUT_DIR} || error "Fail to copy ${SOURCE_CODE_FP} under ${OUTPUT_DIR}"
        fi
        ! extract_tarball ${SOURCE_CODE} ${OUTPUT_DIR} && error "Fail to extract ${SOURCE_CODE}"
    fi
    mkdir -p "${PREFIX}" || error "Fail to setup ${PREFIX} dir"
    cd ${tshark_folder} || error "Fail to 'cd' in ${tshark_folder}"
    ./autogen.sh || error "Fail to autogen Tshark.."
    compile "--prefix=${PREFIX}" \
            '--enable-tshark' \
            '--with-krb5=no' \
            '--with-portaudio=no' \
            '--with-gnutls=no' \
            '--with-gcrypt=no' \
            '--enable-capinfos=no' \
            '--enable-dumpcap=yes' \
            '--enable-mergecap=yes' \
            '--enable-editcap=no' \
            '--disable-idl2wrs' \
            '--disable-randpkt' \
            '--enable-text2pcap=no' \
            '--enable-androiddump=no' \
            '--disable-wireshark' \
            '--disable-warnings-as-errors' \
            || error "Fail to compile wireshark..."
    make install || error "Fail to 'make' installation"
}

remove_tshark() {

    #cleanup the compiled version of Tshark
    local tshark_folder=$(get_tshark_folder)
    [[ ! -d ${tshark_folder} ]] \
        && error "${tshark_folder} is missing, bailing out"
    cd ${tshark_folder} || error "Fail to 'cd' in ${tshark_folder}"
    #display the steps the software would take to install itself
    make -n install > /dev/null || error "Not an compiled software"
    make uninstall || error "Fail to uninstall Tshark"
    make clean &>/dev/null
    cd .. && rm -rf ${tshark_folder}
    rm -rf "${PREFIX}"
    info "Tshark has been uninstalled successfully"
}


help () {

    info "compile: $0 -c <path-to-wireshark-source-code> [-o outputdir] [-t]"
    info "decompile: $0 -d <path-to-wireshark-source-code> [-o outputdir] [-t]"
    info "optional arguments:"
    info "[-h]   : show this help message and exit"
    info "[-o]   : output directory of tshark binary, defaults to current directory"
    info "[-t]   : wireshark source code in compressed format"
    info "[-c]   : compile wireshark"
    info "[-d]   : decompile wireshark, cleanup"
    exit 0
}


### Main ###

[[ $EUID -eq 0 ]] && \
    { install_dependencies || error "Fail to install the necessary dependencies"; }

TAR=false
OUTPUT_DIR="${CURRENT_DIR}"
while getopts ':c:d:o:t' opt; do
    case $opt in
        c) ACTION='compile'
           SOURCE_CODE="${OPTARG}"
           ;;
        d) ACTION='decompile'
           SOURCE_CODE="${OPTARG}"
           ;;
        o) OUTPUT_DIR="${OPTARG}"
           ;;
        t) TAR=true
           ;;
        \?) help
            ;;
        :)  help
            ;;
    esac
done

#No arguments
[[ $OPTIND -eq 1 ]] && help
shift $((OPTIND-1))

SOURCE_CODE_FP=$(readlink -f ${SOURCE_CODE})
PREFIX="${OUTPUT_DIR}/wireshark_e2e"
TSHARK_BIN="${PREFIX}/bin/tshark"

case $ACTION in
   "compile")
              [[ $(source_code_exists) ]] && error "${SOURCE_CODE_FP} does not exist"
              compile_tshark
              info "Tshark installation completed successfully"
              ;;
   "decompile")
              [[ $(source_code_exists) ]] && error "${SOURCE_CODE_FP} does not exist"
              remove_tshark
              ;;
esac
exit $?
