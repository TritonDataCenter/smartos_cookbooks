#
# Cookbook Name:: SmartOS
# Recipe:: default
#
# Copyright 2012, Joyent, Inc.
#
# All rights reserved - Do Not Redistribute
#

## Explicitly allow restart of  name service cache after
## updating resolv.conf
##
service "name-service-cache" do
 supports :enable => true, :start => true, :stop => true, :restart => true
 action [ :enable, :start ]
end


## Enable DNS
##
template "/etc/nsswitch.conf" do
 source "nsswitch.conf.erb"
 owner "root"
 group "sys"
 mode '0644'
 not_if "cat /etc/nsswitch.conf | grep ^hosts: | grep \" dns\""
 notifies :restart, resources(:service => "name-service-cache"), :immediate
end

## DNS Resolver
##
template "/etc/resolv.conf" do
 source "resolv.conf.erb"
 owner "root"
 group "sys"
 mode "0644"
 notifies :restart, resources(:service => "name-service-cache"), :immediate
end

## Set the Hostname
##
if node.attribute?("hostname")
  execute "Set hostname" do
    command "/usr/bin/hostname #{node[:hostname]} && /usr/bin/hostname > /etc/nodename"
    only_if "grep unknown /etc/nodename"
  end
end


## Enable atime on /var, so that WTMPX and logs work properly
##
execute "Enable atime for /var" do
  command "/usr/sbin/zfs set atime=on zones/var"
  only_if "/usr/sbin/zfs get -Hp atime zones/var | grep off"
end

##  Setup SSH for the Root User
##
if node.attribute?("ssh")
  include_recipe "smartos::ssh"
end

## Install 'nicstat'
##
include_recipe "smartos::nicstat"

## Configure NTP
##
include_recipe "smartos::ntp"

## Write the motd
##
include_recipe "smartos::motd"
