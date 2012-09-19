template "/etc/inet/ntp.conf" do
 source "ntp.conf.erb"
end

service "ntp" do
 action :restart
 provider Chef::Provider::Service::Solaris
end

