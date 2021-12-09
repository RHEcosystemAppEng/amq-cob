# Virtualbox RHEL8 VM - Solution to no ip assigned

## Use the nmcli utility

### Virtualbox App and RHEL8 VM settings
* Ensure that the File -> Host Network Manager has Host Only Network configured with DHCP Disabled
* The RHEL8 VM has two network interfaces
    * 1st should be default NAT interface
    * 2nd should be host only network interface

### Configure RHEL8 VM Network with following nmcli commands
* In a terminal window use the following commands
```shell
nmcli connection show

nmcli connection add type ethernet con-name static ifname enp0s8
nmcli connection modify static ipv4.addresses "192.168.56.11/24"
nmcli connection modify static ipv4.method manual
nmcli connection modify static connection.autoconnect no
nmcli connection up static 
nmcli connection show
```

* From Mac terminal try ssh command and see if you are able to connect
```shell
ssh rhkp@192.168.56.11
```