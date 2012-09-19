#
# Cookbook Name:: logging
# Recipe:: default
#
# Copyright 2011, Joyent, Inc.
#
# All rights reserved - Do Not Redistribute
#

## Touch /var/log/authlog
file "/var/log/authlog" do
 owner "root"
 group "root"
 mode "0644"
 action :touch
end

## Touch /var/log/audit
file "/var/log/audit" do
 owner "root"
 group "root"
 mode "0644"
 action :touch
end



### TODO: This should point to a syslog server by attribute
# Solaris Syslog Configuration
template "/etc/syslog.conf" do
  source "syslog.conf.erb"
  owner "root"
  group "sys"
  mode "0644"
  variables(
	:logserver => node[:syslog][:server]
  )
  notifies :restart, "service[system-log]"
end

service "system-log" do
 action :nothing
end

# SSHD Configuration
template "/etc/ssh/sshd_config" do
  source "sshd_config.erb"
  owner "root"
  group "sys"
  mode "0644"
  notifies :restart, "service[ssh]"
end

# Notify hook to restart SSH if configurati is updated.
service "ssh" do
 action :nothing
end

# SU Configuration
template "/etc/default/su" do
  source "su.erb"
  owner "root"
  group "sys"
  mode "0644"
end

# LOGIN Configuration
template "/etc/default/login" do
  source "login.erb"
  owner "root"
  group "sys"
  mode "0644"
end


### TODO: A LWRP should be used to modify properities on a case-by-case
### 		basis, rather than dumping a file and loading it based on
###		on a single property value.

# SVCCFG Command File
cookbook_file "/var/tmp/auditd.props" do
 source "auditd.props"
 owner "root"
 group "sys"
 mode "0644"
end

# Enable BSM SYSLOG Plugin
execute "Enable Audit SYSLOG Plugin" do
 command "/usr/sbin/svccfg -s svc:/system/auditd:default -f /var/tmp/auditd.props"
 only_if "/usr/sbin/svccfg -s svc:/system/auditd:default listprop audit_syslog/active | grep false"
 notifies :run, "execute[refresh auditd]"
end

execute "refresh auditd" do
 command "/usr/sbin/svcadm refresh auditd"
 action :nothing
end
