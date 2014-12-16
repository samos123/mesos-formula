{%- from "mesos/settings.sls" import mesos_settings with context %}

{% set p  = salt['pillar.get']('mesos.spark', {}) %}
{% set g  = salt['grains.get']('mesos.spark', {}) %}

{% set default_download_src = 'http://d3kbcqa49mib13.cloudfront.net/spark-1.1.1-bin-cdh4.tgz' %}
{% set download_src = p.get('download_src', g.get('download_src', default_download_src)) %}
{% set version = p.get('version', g.get('version', 'spark-1.1.1-bin-cdh4')) %}
{% set curl_opts = p.get('curl_opts', g.get('curl_opts', '')) %}
{% set hadoop_home = p.get('hadoop_home', g.get('hadoop_home', '/usr/lib/hadoop')) %}
{% set hadoop_binary = p.get('hadoop_binary', g.get('hadoop_binary', hadoop_home ~ '/bin/hadoop')) %}

{% set namenode_host = p.get('namenode_host', g.get('namenode_host', mesos_settings.master_nodes|first)) %}

{% set spark_settings = {'version': version,
                         'hadoop_home': hadoop_home,
                         'download_src': download_src,
                         'curl_opts': curl_opts,
                         'hadoop_binary': hadoop_binary,
                         'namenode_host': namenode_host} %}
