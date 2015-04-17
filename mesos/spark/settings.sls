{%- from "mesos/settings.sls" import mesos_settings with context %}

{% set p  = salt['pillar.get']('mesos.spark', {}) %}
{% set g  = salt['grains.get']('mesos.spark', {}) %}

{% set versions = {'spark-1.3.0-cdh4': {'download_src': 'http://d3kbcqa49mib13.cloudfront.net/spark-1.3.0-bin-cdh4.tgz',
                                        'md5': '634f1f5401f857f0c45fccfbbb4abfd4'},
                   'spark-1.3.0-hadoop2.4': {'download_src': 'http://d3kbcqa49mib13.cloudfront.net/spark-1.3.0-bin-hadoop2.4.tgz',
                                             'md5': '20dffd5254a2b7e57b76a488cab40cd8'}} %}

{% set version = p.get('version', g.get('version', 'spark-1.3.0-hadoop2.4')) %}

{% set download_src = p.get('download_src', g.get('download_src', versions[version]['download_src'])) %}
{% set download_md5 = p.get('download_md5', g.get('download_md5', versions[version]['md5'])) %}
{% set curl_opts = p.get('curl_opts', g.get('curl_opts', '')) %}
{% set hadoop_home = p.get('hadoop_home', g.get('hadoop_home', '/usr/lib/hadoop')) %}
{% set hadoop_binary = p.get('hadoop_binary', g.get('hadoop_binary', hadoop_home ~ '/bin/hadoop')) %}

{% set namenode_host = p.get('namenode_host', g.get('namenode_host', mesos_settings.master_nodes|first)) %}

{% set spark_settings = {'version': version,
                         'hadoop_home': hadoop_home,
                         'download_src': download_src,
                         'download_md5': download_md5,
                         'curl_opts': curl_opts,
                         'hadoop_binary': hadoop_binary,
                         'namenode_host': namenode_host} %}
