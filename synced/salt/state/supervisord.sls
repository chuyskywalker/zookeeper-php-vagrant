python-pip:
  pkg.installed

# The repo version is WAAAY too old. Even the pip one is a bit out of date
supervisord-app:
  pip.installed:
    - name: supervisor
    - require:
      - pkg: python-pip

/etc/init.d/supervisord:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - source: salt://files/supervisord.init
    - require:
      - pip: supervisord-app
    - watch_in:
      - service: supervisord

/etc/supervisor.d:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - require:
      - pip: supervisord-app
    - watch_in:
      - service: supervisord

/etc/supervisord.conf:
  file.managed:
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://files/supervisord.conf
    - require:
      - pip: supervisord-app
    - watch_in:
      - service: supervisord

supervisord:
  service:
    - running
    - enable: True
    - require:
      - file: /etc/init.d/supervisord
      - file: /etc/supervisor.d
      - file: /etc/supervisord.conf