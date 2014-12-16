{% from "mesos/settings.sls" import mesos_settings with context %}
{% from "mesos/spark/settings.sls" import spark_settings with context %}


download_spark_and_upload_to_hdfs:
  cmd.run:
    - name: >
          curl {{ spark_settings.curl_opts }} '{{ spark_settings.download_src }}' -o /tmp/spark-binary.tar.gz;
          {{ spark_settings['hadoop_binary'] }} fs -mkdir /tmp;
          {{ spark_settings['hadoop_binary'] }} fs -put /tmp/spark-binary.tar.gz  /tmp/{{ spark_settings.version }}.tgz
    - unless: {{ spark_settings['hadoop_binary'] }} fs -test -e /tmp/{{ spark_settings.version }}.tgz
    - shell: /bin/bash
