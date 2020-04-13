#!/bin/bash
# 
# This script installs Chef Inspec on Linux.
# 

DSC_HOME_PATH="$PWD"
LINUX_DISTRO=""
AZURE_STORAGE_URL="https://oaasguestconfigwcuss1.blob.core.windows.net/inspecpkgs"
MAX_DOWNLOAD_RETRY_COUNT=5

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

rotate_azure_storage_url() {
    RETRY_NUM=$1

    AVAILABLE_REGIONS=('WCUS'
        'WE'
        'ASE'
        'BRS'
        'CID'
        'EUS2'
        'NE'
        'SCUS'
        'UKS'
        'WUS2')

    NUM_AVAILABLE_REGIONS=${#AVAILABLE_REGIONS[@]}

    CURRENT_REGION_INDEX=$RETRY_NUM % $NUM_AVAILABLE_REGIONS
    CURRENT_REGION=${AVAILABLE_REGIONS[$CURRENT_REGION_INDEX]}

    AZURE_STORAGE_ENDPOINT="oaasguestconfig${CURRENT_REGION}s1"
    AZURE_STORAGE_URL="https://${AZURE_STORAGE_ENDPOINT}.blob.core.windows.net/inspecpkgs"
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
        return 0
    else
        print_error "Download of package '$PACKAGE_NAME' failed after retrying for $RETRY_MAX_SEC seconds."
        return 1
    fi
}

test_sha256_checksums_match() {
    FILE_TO_CHECK=$1
    EXPECTED_SHA256_CHECKSUM=$2

    echo "Comparing checksums with sha256sum..."
    ACTUAL_SHA256_CHECKSUM=`sha256sum $FILE_TO_CHECK | awk '{ print $1 }'`
    CHECKSUM_RESULT=`test "x$ACTUAL_SHA256_CHECKSUM" = "x$EXPECTED_SHA256_CHECKSUM"`

    if [ $CHECKSUM_RESULT -ne 0 ]; then
        print_error "Package checksum does not match expected checksum."
    else
        echo "Package checksum matches expected checksum."
    fi

    return $CHECKSUM_RESULT
}

download_and_validate_inspec_package() {
    INSPEC_DOWNLOAD_PACKAGE_NAME=$1
    EXPECTED_SHA256_CHECKSUM=$2

    INSPEC_DOWNLOAD_URL="$AZURE_STORAGE_URL/$INSPEC_DOWNLOAD_PACKAGE_NAME"

    download_package_with_curl "InSpec" $INSPEC_DOWNLOAD_URL $INSPEC_DOWNLOAD_PACKAGE_NAME
    if [ $? -ne 0 ]; then
        return 1
    else
        test_sha256_checksums_match "$INSPEC_DOWNLOAD_PACKAGE_NAME" "$EXPECTED_SHA256_CHECKSUM"
        if [ $? -ne 0 ]; then
            return 2
        fi
    fi
    
    return 0
}

download_and_validate_inspec_package_with_retries() {
    INSPEC_DOWNLOAD_PACKAGE_NAME=$1
    EXPECTED_SHA256_CHECKSUM=$2

    NUM_RETRIES=0
    DOWNLOAD_RESULT=1
 
    while [ $NUM_RETRIES -lt $MAX_DOWNLOAD_RETRY_COUNT ] && [ $DOWNLOAD_RESULT -ne 0 ]
    do
        rotate_azure_storage_url $NUM_RETRIES
        echo "Attempting InSpec download from Azure storage URL '$AZURE_STORAGE_URL'..."
        DOWNLOAD_RESULT=`download_and_validate_inspec_package $INSPEC_DOWNLOAD_PACKAGE_NAME $EXPECTED_SHA256_CHECKSUM`
        ((NUM_RETRIES++))
    done

    check_result $DOWNLOAD_RESULT "Download of InSpec failed."
    echo "Download of InSpec succeeded."
}

install_inspec_debian() {
    INSPEC_DOWNLOAD_PACKAGE_NAME="inspec_2.2.61-1_amd64.deb"
    EXPECTED_SHA256_CHECKSUM="aa0f844e34f7b4ee8de7a209808a8921b496c945c8daca5ac4bc045be6b932b7"

    if [ $(dpkg-query -W -f='${Status}' inspec 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        download_and_validate_inspec_package_with_retries $INSPEC_DOWNLOAD_PACKAGE_NAME $EXPECTED_SHA256_CHECKSUM

        echo "Installing InSpec..."
        export DEBIAN_FRONTEND=noninteractive
        dpkg -i "$DSC_HOME_PATH/$INSPEC_DOWNLOAD_PACKAGE_NAME" >/dev/null 2>&1
        check_result $? "Installation of InSpec failed."
        echo "Installation of InSpec succeeded."
    else
        echo "InSpec is already installed."
    fi
}

install_inspec_rpm() {
    INSPEC_DOWNLOAD_PACKAGE_NAME=$1
    EXPECTED_SHA256_CHECKSUM=$2

    if rpm -qa | grep inspec >/dev/null 2>&1; then
        echo "InSpec is already installed."
    else
        download_and_validate_inspec_package_with_retries $INSPEC_DOWNLOAD_PACKAGE_NAME $EXPECTED_SHA256_CHECKSUM

        echo "Installing InSpec..."
        rpm -i "$DSC_HOME_PATH/$INSPEC_DOWNLOAD_PACKAGE_NAME" --nosignature >/dev/null 2>&1
        check_result $? "Installation of InSpec failed."
        echo "Installation of InSpec succeeded."
    fi
}

install_inspec() {
    get_linux_distro
    echo "Checking for InSpec..."
    
    case "$LINUX_DISTRO" in
    "Ubuntu" | "Debian")
        install_inspec_debian
        ;;
    "Red Hat" | "CentOS")
        INSPEC_DOWNLOAD_PACKAGE_NAME="inspec-2.2.61-1.el7.x86_64.rpm"
        EXPECTED_SHA256_CHECKSUM="b19bced48464a01864a4445bb189065ef3465f7ed88836384e6844a982d8c97a"
        install_inspec_rpm $INSPEC_DOWNLOAD_PACKAGE_NAME $EXPECTED_SHA256_CHECKSUM
        ;;
    "SUSE")
        INSPEC_DOWNLOAD_PACKAGE_NAME="inspec-2.2.61-1.sles12.x86_64.rpm"
        EXPECTED_SHA256_CHECKSUM="07a96434173f7f4edd632c335284fc224b3d61f0f040364c8b31e258f9d46288"
        install_inspec_rpm $INSPEC_DOWNLOAD_PACKAGE_NAME $EXPECTED_SHA256_CHECKSUM
        ;;
    *) echo "Could not install InSpec for unexpected Linux distribution '$LINUX_DISTRO'"
        exit 1
        ;;
    esac
}

install_inspec
check_result $? "Inspec installation failed"
