Проект настраивает 2 сервера Debian 12

    на первом сервере:
        - добавление переменной $PATH для суперпользователя;
        - prometheus-node-exporter, mariadb, mysqld_exporter + фаерволл (nftables). 
          Развёртывание предполагается без использования контейнеризации;
        - настройка nftables: закрыты все порты, кроме ssh, prometheus-node-exporter, mariadb, mysqld_exporter. 
          Список открытых портов должен задаваться в виде переменных в ansible.
          Также настройка базы mariadb для корректной работы prometheus-mysqld-exporter
	  
    на втором сервере:
        - добавление переменной $PATH для суперпользователя
        - развертывание docker + docker compose, prometheus и grafana. Файлы конфигураций должны находиться на хосте и монтироваться в контейнеры в режиме ro.
        - В prometheus должен быть организован сбор метрик prometheus-node-exporter и mysqld_exporter
        - В grafana реализовано два dashboard:
	    - общие метрики ОС (cpu, RAM, загруженность сетевых интерфейсов, заполненность диска);
	    - метрики mariadb - количество соединений, количество запросов, отдельно количество чтений (select), отдельно количество остальных операций записи (update, insert, delete).
    
Конфигурационные файлы для контейнеров хранятся по пути docker/prometheus/ и docker/grafana 
В директории configs/ хранятся json-модели dashboard’ов, готовых для импорта в развёрнутое решение
Конфигурационные файлы для бд mariadb и nftables хранятся в configs/ 

Директория pkgs/ подразумевает собой использование в случае отсутствия интернета на первой машине

скрипты ansible/first_VM/first_auto_ansible.sh и ansible/second_VM/second_auto_ansible.sh сделаны для автоматизации, что бы не вызывать плейбуки вручную
Задания по которым был написан проект описаны в файле "devops-engineer-тестовое-задание.odt"

!ПЕРЕД НАЧАЛОМ РАБОТЫ!
Что нужно изменить:
1. ansible/hosts.ini измените IP-адреса машин в соответствии со своими

2. docker/prometheus/prometheus.yml измените IP-адреса для эскпортеров (job для grafana можно не менять, если вы не меняли имя контейнера в docker/docker-compose.yaml)

3. scripts/create_user_and_grant_priv.sh измените MYSQL_ROOT_PASSWORD и MYSQL_EXPORTER_PASSWORD в соответствии со своими данными

4. configs/.my.cnf измените user и password в соответствии со своими данными

5. ansible/first_VM/first_auto_ansible.sh и ansible/second_VM/second_auto_ansible.sh измените строки "ansible_user=user ansible_password=pass ansible_become_method=su/sudo ansible_become_user=root ansible_become_password=pass" в соответствии со своими данными

Как все изменения были проведены можно начинать развертывание:
1.

	- cd ansible/first_VM/
	- ./first_auto_ansible.sh 

2.

        - cd ansible/second_VM/ 
    	- ./second_auto_ansible.sh

Также небольшое пояснение по поводу плейбука ansible/second_VM/second_setting.yml - развертывание докер контейнеров проходит через shell, потому что получая ошибки я нашел такую информацию: "Ошибка KeyError: 'ContainerConfig' при запуске Docker-compose в 2024 году может возникать из-за использования устаревшей версии. Вместо неё нужно использовать команду «docker compose»", а как сделать это в модуле docker_compose в ансибл я не нашел :(
