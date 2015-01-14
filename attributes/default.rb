set[:java][:install_flavor] = 'openjdk'
set[:java][:jdk_version] = '7'

set[:elasticsearch][:version] = '1.2.2'
set[:elasticsearch][:filename] = "elasticsearch-1.2.2.tar.gz"
set[:elasticsearch][:download_url] = [
    node[:elasticsearch][:host],
    node[:elasticsearch][:repository],
    node[:elasticsearch][:filename]
].join('/')

set[:elasticsearch][:cluster][:name] = 'elk-elasticsearch'

# force all memory to be locked, so the JVM doesn't swap memory with disk, crashing server performance
# this is better done though by going into the nodes to the /etc/sysctl.conf and adding the line vm.swappiness = 1
# which still allows swaps in emergencies while blocking it from happenning otherwise
# set[:elasticsearch][:bootstrap][:mlockall] = true


set[:elasticsearch][:plugins]['karmi/elasticsearch-paramedic'] = {}
set[:elasticsearch][:plugins]['royrusso/elasticsearch-HQ'] = {}
set[:elasticsearch][:plugins]['elasticsearch/elasticsearch-cloud-aws']['version'] = '2.2.0'

set[:elasticsearch][:discovery][:type] = 'ec2'
set[:elasticsearch][:discovery][:zen][:ping][:multicast][:enabled] = false

#has some benefits according to this:    http://gibrown.com/2014/01/09/scaling-elasticsearch-part-1-overview/
set[:elasticsearch][:discovery][:zen][:fd][:ping_interval] = '15s'
set[:elasticsearch][:discovery][:zen][:fd][:ping_timeout] =  '60s'
set[:elasticsearch][:discovery][:zen][:fd][:ping_retries] =  '5'

set[:elasticsearch][:discovery][:ec2][:tag]['opsworks:stack'] = node[:opsworks][:stack][:name]
set[:elasticsearch][:cloud][:aws][:region] = node[:opsworks][:instance][:region]

# Allocation awareness
# https://github.com/amazonwebservices/opsworks-elasticsearch-cookbook/blob/813e9cfbd7f7587a5cca885e92274e23d3f23772/layer-custom/recipes/allocation-awareness.rb
set[:elasticsearch][:custom_config] = {
    'node.rack_id' => "#{node[:opsworks][:instance][:availability_zone]}"
}

set[:elasticsearch][:allocated_memory] = "#{(node.memory.total.to_i * 0.5 ).floor / 1024}m"
