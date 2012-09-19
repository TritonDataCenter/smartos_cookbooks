##
## Manage the Root SSH User Configuration
##


## Create ~/.ssh
##
directory "/root/.ssh" do
  owner "root" 
  group "root"
  mode '0700'
end

## Remove authorized_keys, if it exists.
##
#file "/root/.ssh/authorized_keys" do
#  action :delete
#end

## Insert the Public/Private Keys
##
if node.ssh.attribute?("pubkey")
  remote_file "/root/.ssh/id_dsa.pub" do
    source "#{node[:ssh][:pubkey]}"
    owner "root"
    group "root"
    mode '0644'
    action :create_if_missing
  end
end

if node.ssh.attribute?("privkey")
  remote_file "/root/.ssh/id_dsa" do
    source "#{node[:ssh][:privkey]}"
    owner "root"
    group "root"
    mode '0600'
    action :create_if_missing
  end
end

## Authorized Keys
##
if node.ssh.attribute?("authorized_keys")
  template  "/root/.ssh/authorized_keys" do
    source "authorized_keys.erb"
  end
end
