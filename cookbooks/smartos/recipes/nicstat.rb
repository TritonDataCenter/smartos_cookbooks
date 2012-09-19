##
##  Install Tim Cook's nicstat per Brendan's Request
##  SRC: http://sourceforge.net/projects/nicstat/files/latest/download
##



cookbook_file "/opt/custom/bin/nicstat" do
  source "nicstat"
  owner "root"
  group "root"
  mode "0755"
end
