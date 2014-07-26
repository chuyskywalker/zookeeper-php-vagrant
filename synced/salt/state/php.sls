include:
 - remi-repo

php:
  pkg.installed:
    - name: php
    - pkgs:
      - php-cli
      - php-common
      - php-devel

php-timezone:
  cmd.run:
    - name: echo 'date.timezone = "UTC"' >> /etc/php.ini
    - unless: grep UTC /etc/php.ini
    - require:
      - pkg: php

php-zookeeper:
  pecl.installed:
    - name: zookeeper
    - preferred_state: beta
    - require:
      - pkg: php