include:
 - supervisord

cdh-repo:
  pkgrepo.managed:
    - name: cloudera-cdh5
    - humanname: Cloudera's Distribution for Hadoop, Version 5
    - baseurl: http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/5/
    - gpgkey: http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera
    - gpgcheck: 1
    - enabled: 1

java-1.7.0-openjdk-devel:
  pkg.installed

zookeeper:
  pkg.installed:
    - pkgs:
      - zookeeper
      - zookeeper-native
    - require:
      - pkgrepo: cdh-repo

{% for port in (1,2,3) %}

zk-{{ port }}-data-dir:
  file.directory:
    - name: /var/zookeeper/zk{{ port }}/data
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True

zk-{{ port }}-data-and-id:
  cmd.run:
    - name: /usr/lib/zookeeper/bin/zkServer-initialize.sh --configfile=/var/zookeeper/zk{{ port }}/conf/zoo.cfg --myid={{ port }}
    - onlyif: 'test ! -e /var/zookeeper/zk{{ port }}/data/myid'
    - require:
      - file: zk-{{ port }}-data-dir
      - file: zk-{{ port }}-cfg

zk-{{ port }}-conf-dir:
  file.directory:
    - name: /var/zookeeper/zk{{ port }}/conf
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True

zk-{{ port }}-cfg:
  file.managed:
    - name: /var/zookeeper/zk{{ port }}/conf/zoo.cfg
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://files/zoo.cfg
    - defaults:
        port: {{ port }}
    - require:
      - file: zk-{{ port }}-conf-dir

zk-{{ port }}-log-cfg:
  file.managed:
    - name: /var/zookeeper/zk{{ port }}/conf/log4j.properties
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://files/zoo-log4j.properties.cfg
    - defaults:
        port: {{ port }}
    - require:
      - file: zk-{{ port }}-conf-dir

zk-{{ port }}-supervisor:
  file.managed:
    - name: /etc/supervisor.d/zook-{{ port }}.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://files/zoo.supervisor.conf
    - defaults:
        port: {{ port }}
    - require:
      - file: zk-{{ port }}-data-dir
      - file: zk-{{ port }}-conf-dir
      - file: /etc/supervisor.d
    - watch_in:
      - service: supervisord

{% endfor %}
