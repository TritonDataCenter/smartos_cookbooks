##
## Joyent Customer MOTD
##

template  "/etc/motd" do
  source "motd.erb"
  owner "root"
  group "sys"
  mode "0644"
end
