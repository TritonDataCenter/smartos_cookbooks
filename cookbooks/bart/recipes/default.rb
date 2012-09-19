#
# Cookbook Name:: BART 
# Recipe:: default
#
# Copyright 2011, Joyent, Inc.
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "/opt/custom/bin/bartlog" do
 source "bartlog"
 owner "root" 
 group "sys"
 mode "0755"
end

cookbook_file "/etc/bart.rules" do
 source "bart.rules"
 owner "root" 
 group "sys"
 mode "0644"
end


cron "BARTlog" do
 command "/opt/custom/bin/bartlog"
 minute "0"
 hour "0"
end
