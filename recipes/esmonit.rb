case node[:platform]
when 'centos','redhat','fedora','suse','amazon'
    template "/etc/monit.d/elasticsearch-monit.conf" do
        source "elasticsearch.monitrc.conf.erb"
        mode 0440
        owner "root"
        group "root"
    end
when 'debian','ubuntu'
    template "/etc/monit/conf.d/elasticsearch-monit.conf" do
        source "elasticsearch.monitrc.conf.erb"
        mode 0440
        owner "root"
        group "root"
    end
end


