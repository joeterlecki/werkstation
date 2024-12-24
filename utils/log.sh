#!/usr/bin/env bash

log() {
    local level=$1
    local message=$2
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    # ANSI color codes
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local PURPLE='\033[0;35m'
    local NC='\033[0m'
    
    case $level in
        "INFO")
            echo -e "${GREEN}[INFO]${NC} $timestamp $message"
            ;;
        "WARN")
            echo -e "${YELLOW}[WARN]${NC} $timestamp $message" >&2
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $timestamp $message" >&2
            ;;
        "SECTION")
            echo -e "\n${PURPLE}====== $message ======${NC}\n"
            ;;
        *)
            echo -e "$timestamp $message"
            ;;
    esac
}

log_info()    { log "INFO" "$1"; }
log_warn()    { log "WARN" "$1"; }
log_error()   { log "ERROR" "$1"; }
log_section() { log "SECTION" "$1"; }