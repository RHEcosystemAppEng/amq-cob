#!/bin/sh


#============================================================================
# Script to retrieve public ip output for each of the instance running in the
# given region and print it in the "<ip> <hostname>" format
#============================================================================


#------------------------------------------------------------------------------------------------------------------
# Displays usage and exits
#
# @param message to display before usage
#------------------------------------------------------------------------------------------------------------------
function USAGE() {
    local message="$1"

    if [ ! -z "$message" ]; then
        echo $message
    fi

    cat <<- USAGE_INFO
      Usage: $0 -r <region> -d <region_dir>
        where
          region is one of r1 or r2
          region_dir is the directory for the specified region

        e.g: $0 -r r1 -d toronto
             This will extract hostname and public ip addresses from terraform config in "toronto" directory,
             for the servers running in region 1 and display them on the stdout
        e.g: $0 -r r2 -d dallas
             This will extract hostname and public ip addresses from terraform config in "dallas" directory,
             for the servers running in region 2 and display them on the stdout
USAGE_INFO

    exit 1
}

#------------------------------------------------------------------------------------------------------------------
# Retrieves public ip output for each of the instance running in the given region and print it in the
# following format:
#    <ip_address> <hostname>
#------------------------------------------------------------------------------------------------------------------
function print_ip_and_hostname() {
  local region="$1"
  local region_dir="$2"
  local instance_name

  local curr_dir=`pwd`
  cd "$region_dir"

  echo "Running terraform output for getting public_ip in [$region_dir]..."
  printf "\nPaste the ip + hostname given below (between START and END tags) to /etc/hosts\n[START] Copy from next line -->>\n\n"

  for i in vpc1-broker01-live-public_ip vpc1-broker02-bak-public_ip vpc1-broker03-live-public_ip \
           vpc1-broker04-bak-public_ip vpc1-nfs-server-public_ip vpc1-router01-hub-public_ip \
           vpc1-router02-spoke-public_ip vpc2-broker05-live-public_ip vpc2-broker06-bak-public_ip \
           vpc2-broker07-live-public_ip vpc2-broker08-bak-public_ip vpc2-nfs-server-public_ip \
           vpc2-router03-spoke-public_ip
  do
      ip=`terraform output $i | sed 's/"//g'`
      if [ ! -z "$ip" ]; then
        instance_name=`echo $i | sed 's/-public_ip//'`   # remove "-public_ip" from the instance name
        case $instance_name in
          "vpc1-nfs-server"|"vpc2-nfs-server")
            instance_name="$region-$instance_name"
            ;;
          *)
            instance_name="$region-`echo $instance_name | sed 's/vpc[12]-//'`"  # remove vpc info from instance name
        esac

        printf "%-18s %s\n" "$ip"  "$instance_name"
      else
        echo "Unable to find the IP"
      fi
  done
  printf "\n<<-- [END] Select till previous line\n"

  cd "$curr_dir"
}


#------------------------------------------------------------------------------------------------------------------
# Function that parses the command line args and executes in following manner if all the arguments are present:
#  - extracts ip addresses for all the instances running in the given region
#  - prints the extracted ip addresses along with their hosts
#
# Command line arguments are expected with following flag:
#  -r|R: region (r1 or r2) - case insensitive
#  -d|D: directory for the region - relative to the script location
#------------------------------------------------------------------------------------------------------------------
function process_cmd_args() {
    if [ $# -eq 0 ]; then
        USAGE
    fi

    local region
    local region_dir
    local incorrectUsageMessage

    while getopts r:R:d:D: arg
    do
        case $arg in
          r|R)
            case "${OPTARG}" in
                [rR][12])
                    region="$OPTARG"
                    ;;
                *)
                    incorrectUsageMessage="** INVALID region: [$OPTARG]. Only r1 or r2 are supported.";;
            esac
            ;;
          d|D)
            region_dir="${OPTARG}"
            if [ ! -d "$region_dir" ]; then
              incorrectUsageMessage="Region directory [$region_dir] does not exist. Please provide a valid region directory..."
            fi
            ;;
          *)
            incorrectUsageMessage="** INVALID option: [$arg]. Only r|R is valid option";;
        esac
    done

    if [ ! -z "${incorrectUsageMessage}" ]; then
        USAGE "${incorrectUsageMessage}"
    fi

    print_ip_and_hostname $region $region_dir
}

process_cmd_args "$@"
