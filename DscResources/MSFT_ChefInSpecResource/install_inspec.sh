#!/bin/bash
# 
# This script installs Chef Inspec on Linux
# 

DSC_HOME_PATH="$PWD"
LINUX_DISTRO=""

print_error() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

check_result() {
    if [ $1 -ne 0 ]; then
        print_error $2
        exit $1
    fi
}

get_linux_distro() {
    if [ ! -z $LINUX_DISTRO ]; then
        return
    fi

    VERSION_OUTPUT=$(cat /proc/version)

    if [[ $VERSION_OUTPUT = *"Ubuntu"* ]]; then
        LINUX_DISTRO="Ubuntu"
    elif [[ $VERSION_OUTPUT = *"Red Hat"* ]]; then
        LINUX_DISTRO="Red Hat"
    elif [[ $VERSION_OUTPUT = *"SUSE"* ]]; then
        LINUX_DISTRO="SUSE"
    elif [[ $VERSION_OUTPUT = *"CentOS"* ]]; then
        LINUX_DISTRO="CentOS"
    elif [[ $VERSION_OUTPUT = *"Debian"* ]]; then
        LINUX_DISTRO="Debian"
    else
        print_error "Unexpected Linux distribution. Expected Linux distributions include only Ubuntu, Red Hat, SUSE, CentOS, and Debian."
        exit 1
    fi

    echo "Linux distribution is $LINUX_DISTRO."
}

download_package_with_curl() {
    PACKAGE_NAME=$1
    PACKAGE_URL=$2
    DOWNLOAD_PACKAGE_NAME=$3
    DOWNLOAD_SUCCEEDED=false
    TOTAL_RETRY_SEC=0
    RETRY_SLEEP_INTERVAL_SEC=5
    RETRY_MAX_SEC=60
    CURL_MAX_SEC=120

    while [ $TOTAL_RETRY_SEC -lt $RETRY_MAX_SEC ] &&  [ "$DOWNLOAD_SUCCEEDED" = false ]; do
        if [ $TOTAL_RETRY_SEC -gt 0 ]; then
            echo "Retrying after $RETRY_SLEEP_INTERVAL_SEC seconds..."
            sleep $RETRY_SLEEP_INTERVAL_SEC
        fi

        echo "Downloading package '$PACKAGE_NAME' from the URL '$PACKAGE_URL'..."
        HTTP_RESPONSE_CODE=$(curl -sS -w "%{http_code}" -o $DOWNLOAD_PACKAGE_NAME -m $CURL_MAX_SEC $PACKAGE_URL)
        CURL_RESPONSE_CODE=$?
        if [ $CURL_RESPONSE_CODE -eq 0 ]; then
            if [ $HTTP_RESPONSE_CODE -ne 200 ]; then
                print_error "Download of package '$PACKAGE_NAME' failed with the HTTP response code '$HTTP_RESPONSE_CODE'."
            else
                DOWNLOAD_SUCCEEDED=true
            fi
        else
            print_error "Download of package '$PACKAGE_NAME' failed with the CURL response code '$CURL_RESPONSE_CODE'."
        fi

        TOTAL_RETRY_SEC+=$RETRY_SLEEP_INTERVAL_SEC
    done

    if [ "$DOWNLOAD_SUCCEEDED" = true ]; then
        echo "Download of package '$PACKAGE_NAME' succeeded."
    else
        print_error "Download of package '$PACKAGE_NAME' failed after retrying for $RETRY_MAX_SEC seconds."
        exit 1
    fi
}

install_inspec() {
    get_linux_distro
    echo "Checking for InSpec..."

    case "$LINUX_DISTRO" in
    "Ubuntu")
        if [ $(dpkg-query -W -f='${Status}' inspec 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
            UBUNTU_VERSION=$(lsb_release -r -s)

            INSPEC_DOWNLOAD_PACKAGE_NAME="inspec_2.2.61-1_amd64.deb"
            INSPEC_DOWNLOAD_URL="https://packages.chef.io/files/stable/inspec/2.2.61/ubuntu/$UBUNTU_VERSION/$INSPEC_DOWNLOAD_PACKAGE_NAME"
            download_package_with_curl "InSpec" $INSPEC_DOWNLOAD_URL $INSPEC_DOWNLOAD_PACKAGE_NAME

            echo "Installing InSpec..."
            export DEBIAN_FRONTEND=noninteractive
            dpkg -i "$DSC_HOME_PATH/$INSPEC_DOWNLOAD_PACKAGE_NAME" >/dev/null 2>&1
            check_result $? "Installation of InSpec failed."
            echo "Installation of InSpec succeeded."
        else
            echo "InSpec is already installed."
        fi
        ;;
    "Red Hat")
        if rpm -qa | grep inspec >/dev/null 2>&1; then
            echo "InSpec is already installed."
        else
            INSPEC_DOWNLOAD_PACKAGE_NAME="inspec-2.2.61-1.el7.x86_64.rpm"
            INSPEC_DOWNLOAD_URL="https://packages.chef.io/files/stable/inspec/2.2.61/el/7/$INSPEC_DOWNLOAD_PACKAGE_NAME"
            download_package_with_curl "InSpec" $INSPEC_DOWNLOAD_URL $INSPEC_DOWNLOAD_PACKAGE_NAME

            echo "Installing InSpec..."
            rpm -i "$DSC_HOME_PATH/$INSPEC_DOWNLOAD_PACKAGE_NAME" --nosignature >/dev/null 2>&1
            check_result $? "Installation of InSpec failed."
            echo "Installation of InSpec succeeded."
        fi
        ;;
    "SUSE")
        if rpm -qa | grep inspec >/dev/null 2>&1; then
            echo "InSpec is already installed."
        else
            INSPEC_DOWNLOAD_PACKAGE_NAME="inspec-2.2.61-1.sles12.x86_64.rpm"
            INSPEC_DOWNLOAD_URL="https://packages.chef.io/files/stable/inspec/2.2.61/sles/12/$INSPEC_DOWNLOAD_PACKAGE_NAME"
            download_package_with_curl "InSpec" $INSPEC_DOWNLOAD_URL $INSPEC_DOWNLOAD_PACKAGE_NAME

            echo "Installing InSpec..."
            rpm -i "$DSC_HOME_PATH/$INSPEC_DOWNLOAD_PACKAGE_NAME" --nosignature >/dev/null 2>&1
            check_result $? "Installation of InSpec failed."
            echo "Installation of InSpec succeeded."
        fi
        ;;
    "CentOS")
        if rpm -qa | grep inspec >/dev/null 2>&1; then
            echo "InSpec is already installed."
        else
            INSPEC_DOWNLOAD_PACKAGE_NAME="inspec-2.2.61-1.el7.x86_64.rpm"
            INSPEC_DOWNLOAD_URL="https://packages.chef.io/files/stable/inspec/2.2.61/el/7/$INSPEC_DOWNLOAD_PACKAGE_NAME"
            download_package_with_curl "InSpec" $INSPEC_DOWNLOAD_URL $INSPEC_DOWNLOAD_PACKAGE_NAME

            echo "Installing InSpec..."
            rpm -i "$DSC_HOME_PATH/$INSPEC_DOWNLOAD_PACKAGE_NAME" --nosignature >/dev/null 2>&1
            check_result $? "Installation of InSpec failed."
            echo "Installation of InSpec succeeded."
        fi
        ;;
    "Debian")
        if [ $(dpkg-query -W -f='${Status}' inspec 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
            INSPEC_DOWNLOAD_PACKAGE_NAME="inspec_2.2.61-1_amd64.deb"
            INSPEC_DOWNLOAD_URL="https://packages.chef.io/files/stable/inspec/2.2.61/ubuntu/14.04/$INSPEC_DOWNLOAD_PACKAGE_NAME"
            download_package_with_curl "InSpec" $INSPEC_DOWNLOAD_URL $INSPEC_DOWNLOAD_PACKAGE_NAME

            echo "Installing InSpec..."
            export DEBIAN_FRONTEND=noninteractive
            dpkg -i "$DSC_HOME_PATH/$INSPEC_DOWNLOAD_PACKAGE_NAME" >/dev/null 2>&1
            check_result $? "Installation of InSpec failed."
            echo "Installation of InSpec succeeded."
            
        else
            echo "InSpec is already installed."
        fi
        ;;
    *) echo "Could not install InSpec for unexpected Linux distribution '$LINUX_DISTRO'"
        exit 1
        ;;
    esac
}

install_inspec
check_result $? "Inspec installation failed"


