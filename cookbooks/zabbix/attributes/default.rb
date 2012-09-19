#
# Zabbix Attribute Defaults
#

## Headnodes typically have the hostname "headnode", 
##  use this attribute to override it with something more descriptive
##  Please do not change it here, change it in your node attribute file.
#default[:zabbix][:hostname] = "override-hostname"

## The Zabbix Server/Proxy for agents to talk to,
##  Please override it in your node attribute file, this value is just
##  a fallback value in case you forget.
default[:zabbix][:server] = "192.168.100.10"	

## Default external NIC which is monitored by Zabbix
default[:zabbix][:external_nic] = "ixgbe0"


