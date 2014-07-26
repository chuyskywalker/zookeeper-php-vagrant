include:
 - supervisord

java-1.7.0-openjdk-devel:
  pkg.installed

zookeeper-server:
  archive.extracted:
    - name: /opt/
    - source: http://apache.xl-mirror.nl/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
    - source_hash: md5=971c379ba65714fd25dc5fe8f14e9ad1
    - archive_format: tar
    - tar_options: z
    - if_missing: /opt/zookeeper-3.4.6/

{% for port in (1,2,3) %}

zk-{{ port }}-dir:
  file.directory:
    - name: /var/zookeeper/zk{{ port }}/data
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True

zk-{{ port }}-cfg:
  file.managed:
    - name: /var/zookeeper/zk{{ port }}/zoo.cfg
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://files/zoo.cfg
    - defaults:
        port: {{ port }}
    - require:
      - file: zk-{{ port }}-dir

zk-{{ port }}-id:
  file.managed:
    - name: /var/zookeeper/zk{{ port }}/data/myid
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://files/zooid.cfg
    - defaults:
        port: {{ port }}
    - require:
      - file: zk-{{ port }}-dir

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
      - file: zk-{{ port }}-dir
      - file: /etc/supervisor.d
    - watch_in:
      - service: supervisord

{% endfor %}
