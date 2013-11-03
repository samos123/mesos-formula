{% from "mesos/map.jinja" import mesos with context %}
{% from "mesos/settings.sls" import mesos_settings with context %}

mesos_repo:
  pkgrepo.managed:
    - humanname: Mesos repo
    - name: deb http://repos.mesosphere.io/ubuntu trusty main
    - file: /etc/apt/sources.list.d/mesosphere.list
    - keyid: E56151BF
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: {{ mesos.pkg }}

{{ mesos.pkg }}:
    pkg.installed

/etc/mesos/zk:
  file.managed:
    - source: salt://mesos/files/mesos-zk.jinja
    - template: jinja
    - context:
        servers: {{ mesos_settings.zookeeper_servers }}

{% if salt['match.' ~ mesos_settings.targeting_method](mesos_settings.masters_target) %}
/etc/zookeeper/conf/myid:
  file.blockreplace:
    - content: '{{ mesos_settings.zookeeper_id|string }}'
    - marker_start: "# START auto-management of zookeeper id -DO-NOT-EDIT-"
    - marker_end: "# END --"
    - append_if_not_found: True

/etc/zookeeper/conf/zoo.cfg:
  file.managed:
    - template: jinja
    - source: salt://mesos/files/zoo.cfg.jinja
    - context:
        servers: {{ mesos_settings.zookeeper_servers }}

service zookeeper restart:
  cmd.run:
    - watch:
      - file: /etc/zookeeper/conf/myid
      - file: /etc/zookeeper/conf/zoo.cfg

zookeeper:
  service:
    - running
    - enable: True

{% if mesos_settings.master_nodes|length > 2 %}
/etc/mesos-master/quorum:
  file.managed:
    - contents: 2

service mesos-master restart:
  cmd.run:
    - watch:
       - file: /etc/mesos-master/quorum
{% endif %}

{% endif %}


{% if salt['match.' ~ mesos_settings.targeting_method](mesos_settings.masters_target) and
      salt['match.' ~ mesos_settings.targeting_method](mesos_settings.slaves_target) %}
# In case this node is a mesos master and a slave
mesos-master-and-slave-services:
  service:
    - running
    - enable: True
    - names:
      - {{ mesos.service.master }}
      - {{ mesos.service.slave }}

{% elif salt['match.' ~ mesos_settings.targeting_method](mesos_settings.masters_target) %}
# This node is a only a master so disable slave service and only enable master service
mesos-master-services:
  service:
    - running
    - enable: True
    - names:
      - {{ mesos.service.master }}

mesos-slave-zookeeper-service-dead:
  service:
    - dead
    - enable: False
    - names:
      - {{ mesos.service.slave }}

{% elif salt['match.' ~ mesos_settings.targeting_method](mesos_settings.slaves_target) %}
# In case the node is a slave only
mesos-master-services:
  service:
    - running
    - enable: True
    - names:
      - {{ mesos.service.slave }}

mesos-slave-zookeeper-service-dead:
  service:
    - dead
    - enable: False
    - names:
      - {{ mesos.service.master }}
      - zookeeper

{% endif %}
