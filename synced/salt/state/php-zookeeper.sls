include:
 - php
 - zookeeper

php-zookeeper:
  pecl.installed:
    - name: zookeeper
    - preferred_state: beta
    - require:
      - pkg: php