{% set p  = salt['pillar.get']('mesos', {}) %}
{% set g  = salt['grains.get']('mesos', {}) %}

{% set default_dist_id = 'mesosphere-0.2.1' %}
{% set dist_id = g.get('version', p.get('version', default_dist_id)) %}

{% set java_home = salt['pillar.get']('java_home', '/usr/lib/java') %}

{% set masters_target = p.get('masters_target', g.get('masters_target', 'G@roles:mesos_master')) %}
{% set slaves_target = p.get('slaves_target', g.get('masters_target', 'G@roles:mesos_slave')) %}
{% set zookeeper_target = p.get('zookeeper_target', g.get('zookeeper_target', 'G@roles:mesos_master')) %}
{% set targeting_method = p.get('targeting_method', g.get('targeting_method', 'compound')) %}

{% set master_nodes = salt['mine.get'](masters_target, 'network.interfaces', expr_form=targeting_method) %}
{% set mesos_slaves = salt['mine.get'](slaves_target, 'network.interfaces', expr_form=targeting_method) %}
{% set zookeeper_servers = salt['publish.publish'](zookeeper_target, 'network.interfaces', expr_form=targeting_method) %}

{% set zookeeper_id = p.get('zookeeper_id', g.get('zookeeper_id', '1')) %}

{% set mesos_settings = {'master_nodes': master_nodes,
                         'slave_nodes': slave_nodes,
                         'zookeeper_servers': zookeeper_servers,
                         'masters_target': masters_target,
                         'slaves_target': slaves_target,
                         'targeting_method': targeting_method,
                         'zookeeper_target': zookeeper_target,
                         'zookeeper_id': zookeeper_id,
                         'java_home': java_home} %}
