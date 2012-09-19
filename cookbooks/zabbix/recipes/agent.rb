##
## Zabbix Client Installation
##


## Find the admin interface, whether it be bnx0 or bnx1. [ This is pretty primative, should evolve over time. ]
if defined?(node[:network][:interfaces][:bnx0][:addresses]) then
  local_addr = node[:network][:interfaces][:bnx0][:addresses].find {|addr, addr_info| addr_info[:family] == "inet"}.first
elsif defined?(node[:network][:interfaces][:bnx1][:addresses])
  local_addr = node[:network][:interfaces][:bnx1][:addresses].find {|addr, addr_info| addr_info[:family] == "inet"}.first
end



user "zabbix" do
  uid 42
  gid "bin" 
  home "/"
  shell "/bin/sh"
end


remote_directory "/opt/zabbix" do
  source "zabbix"
  files_owner "root"
  files_group "root"
  files_mode '0755'
  owner "root"
  group "root" 
  mode '0755'
end

directory "/opt/zabbix/etc" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

### The following is commented out, we may use it in the future, but not yet.
### Location for UserParameter Add-ons:
#remote_directory "/opt/zabbix/etc/zabbix_agentd" do
#  source "zabbix_agentd"
#  files_owner "root"
#  files_group "root"
#  files_mode '0755'
#  owner "root"
#  group "root" 
#  mode '0755'
#end

template "/opt/zabbix/etc/zabbix_agentd.conf" do
 source "zabbix_agentd.conf.erb"
 variables(
        :server_ip => node[:zabbix][:server],
        :listen_ip => local_addr,
	:external_nic => node[:zabbix][:external_nic]
 )
 owner "root" 
 group "root" 
 mode '0644'
 notifies :restart, "service[zabbix/agent]"
end

## Create Zabbix Readable Version of Sysinfo in /tmp
execute "Copy sysinfo for Zabbix" do
  command "cp /tmp/.sysinfo.parsable /tmp/.sysinfo.zabbix && chown zabbix /tmp/.sysinfo.zabbix "
  creates "/tmp/.sysinfo.zabbix"
  only_if "ls -l /tmp/.sysinfo.parsable"
end

## Prep the log file:
file "/var/log/zabbix_agentd.log" do
  owner "zabbix"
  group "bin"
  mode '0644'
end

execute "Zabbix Log Rotation" do
  command 'echo "/var/log/zabbix_agentd.log  -c -C 3 -s 10m" >> /etc/logadm.conf'
  not_if "grep zabbix_agentd /etc/logadm.conf"
end

## Import and Start the SMF Manifest
execute "Import SMF Manifest" do
  command "svccfg import /opt/zabbix/share/svc/zabbix_agent.xml"
  not_if "svcs -H zabbix/agent"
end

service "zabbix/agent" do
 action [ :start, :enable ]
 provider Chef::Provider::Service::Solaris
end
