#!/bin/bash

ansible-playbook second_setting.yml -e "ansible_user=user ansible_password=1 ansible_become_method=su ansible_become_user=root ansible_become_password=1" -vvvv
