#!/bin/bash


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
      Usage: $0 -r <region> -d <region_dir> -a -s <suffix>
        where
          region is one of r1 or r2
          region_dir is the directory for the specified region
          -a is for ansible yaml format. The output will be in ansible yaml format
          -s allows a suffix to be passed on, which will be added at the end of each hostname

        e.g: $0 -r r1 -d toronto
             This will extract hostname and public ip addresses from terraform config in "toronto" directory,
             for the servers running in region 1 and display them on the stdout
        e.g: $0 -r r2 -d dallas
             This will extract hostname and public ip addresses from terraform config in "dallas" directory,
             for the servers running in region 2 and display them on the stdout
        e.g: $0 -r r2 -d dallas -s ".ip" -a
             This will extract hostname and public ip addresses from terraform config in "dallas" directory,
             for the servers running in region 2 and display them on the stdout.
             The output will be in ansible yaml format:
                <hostname+prefix>: <ip_address>
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
  local ansible_yaml_format="$3"
  local suffix="$4"
  local instance_name
  local host_file="/etc/hosts"
  local hosts_ip_not_found

  local curr_dir=`pwd`
  cd "$region_dir"

  if [ "$ansible_yaml_format" == "yes" ]; then
    host_file="hosts.yml under global vars"
  fi

  echo "Running terraform output for getting public_ip in [$region_dir]..."
  printf "\nPaste the ip + hostname given below (between START and END tags) to ${host_file}\n[START] Copy from next line -->>\n\n"

  local region_org=$region
  # Handle both regions
  if [ "$region" == "both" ]; then
    region="r1 r2"
  fi

  for i in vpc1-broker01-live-public_ip vpc1-broker02-bak-public_ip vpc1-broker03-live-public_ip \
           vpc1-broker04-bak-public_ip vpc1-nfs-server-public_ip vpc1-router01-hub-public_ip \
           vpc1-router02-spoke-public_ip vpc2-broker05-live-public_ip vpc2-broker06-bak-public_ip \
           vpc2-broker07-live-public_ip vpc2-broker08-bak-public_ip vpc2-nfs-server-public_ip \
           vpc2-router03-spoke-public_ip
  do
    for rgn in $region
    do

      # If both regions are specified, use region prefix before the output. Otherwise use the output as is
      if [ "$region_org" == "both" ]; then
        ip=`terraform output "$rgn-$i" 2>&1 | sed 's/"//g'`
      else
        ip=`terraform output $i 2>&1 | sed 's/"//g'`
      fi

#      echo "Region=[$rgn], ip=[$ip]"
      if [ ! -z "$ip" ]; then
        instance_name=`echo $i | sed 's/-public_ip//'`   # remove "-public_ip" from the instance name
        case $ip in
          *"No outputs found"*|*"not found"*)
            # Warning or error on output not found. Ignore it
            if [ -z "$hosts_ip_not_found" ]; then
              hosts_ip_not_found=$instance_name
            else
              hosts_ip_not_found="$hosts_ip_not_found, $instance_name"
            fi
           ;;
          *)
            case $instance_name in
              "vpc1-nfs-server"|"vpc2-nfs-server")
                instance_name="$rgn-$instance_name"
                ;;
              *)
                instance_name="$rgn-`echo $instance_name | sed 's/vpc[12]-//'`"  # remove vpc info from instance name
            esac

            if [ "$ansible_yaml_format" == "yes" ]; then
              printf "%-25s %s\n" "${instance_name}${suffix}:" "$ip" | tr '-' '_'
            else
              printf "%-18s %s\n" "$ip"  "${instance_name}${suffix}"
            fi
        esac

      else
        echo "error: Unable to find the IP for $i"
      fi
    done
  done

  printf "\n<<-- [END] Select till previous line\n"

  if [ ! -z "$hosts_ip_not_found" ]; then
    printf "\n IP not found for %s\n" "$hosts_ip_not_found"
  fi

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
    local suffix
    local ansible_format="no"
    local incorrectUsageMessage

    while getopts r:R:d:D:s:S:aA arg
    do
        case $arg in
          r|R)
            case "${OPTARG}" in
                [rR][12])
                    region="$OPTARG"
                    ;;
                "both")
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
          s|S)
            suffix="${OPTARG}"
            ;;
          a|A)
            ansible_format="yes"
            ;;
          *)
            incorrectUsageMessage="** INVALID option: [$arg]. Valid options are: r|R, d|D and s|S";;
        esac
    done

    if [ ! -z "${incorrectUsageMessage}" ]; then
        USAGE "${incorrectUsageMessage}"
    fi

    print_ip_and_hostname $region $region_dir $ansible_format $suffix
}

process_cmd_args "$@"
