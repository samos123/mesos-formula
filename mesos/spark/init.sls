{% from "mesos/settings.sls" import mesos_settings with context %}
{% from "mesos/spark/settings.sls" import spark_settings with context %}

/etc/default/mesos:
  file.append:
    - text: |
        HADOOP_HOME={{ spark_settings.hadoop_home }}
        export PATH=$PATH:{{ spark_settings.hadoop_home }}/bin


extract_spark_and_install_locally:
  cmd.run:
      - name: curl {{ spark_settings.curl_opts }} '{{ spark_settings.download_src }}' -o /tmp/spark-binary.tar.gz
      - creates: /opt/{{ spark_settings.version }}
      - require_in:
        - archive: extract_spark_and_install_locally
  archive:
    - extracted
    - name: /opt/
    - source: /tmp/spark-binary.tar.gz
    - archive_format: tar
    - source_hash: md5=1aa72cf067d3e437b9d4e035b9c201d4
    - tar_options: xz
    - if_missing: /opt/{{ spark_settings.version }}
  file.managed:
    - name: /etc/profile.d/spark.sh
    - contents: "export PATH=/opt/{{ spark_settings.version }}/bin:$PATH"


config_spark:
  file.managed:
    - name: /opt/{{ spark_settings.version }}/conf/spark-env.sh
    - contents: |
        export MESOS_NATIVE_LIBRARY=/usr/local/lib/libmesos.so
        export SPARK_EXECUTOR_URI=hdfs://{{ spark_settings.namenode_host }}/tmp/{{ spark_settings.version }}.tgz
        export MASTER=mesos://zk://{{ mesos_settings.master_nodes|first }}:2181/mesos

/opt/{{ spark_settings.version }}/conf/spark-defaults.conf:
  file.managed:
    - contents: |
        master                  mesos://zk://{{ mesos_settings.master_nodes|first }}:2181/mesos
        spark.executor.uri      hdfs://{{ spark_settings.namenode_host }}/tmp/{{ spark_settings.version }}.tgz
