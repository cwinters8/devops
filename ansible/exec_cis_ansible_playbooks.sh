INVDIR=/Users/clark.wintersibm.com/CISAUTOMATION/ansible_deployment/InventoryDefinition/inventory

# install LDAP 
ansible-playbook -i /etc/ansible/othrd/inventory/hosts-othrd install_Full_LDAP_Playbook.yml -e payload=LDAP_Application.yml -e @${INVDIR}/group_vars/ldap-all \
-e @../roles/db2-hadr-base/vars/main.yml -e @${INVDIR}/group_vars/ldap-server-rw

# execute LDAP Command to check replication status
ansible-playbook execute_LDAP_Command_Playbook.yml -e ldap_cmd_type=checkReplStatusQ -e payload=LDAP_Application.yml -e @${INVDIR}/group_vars/ldap-all -e @${INVDIR}/group_vars/ldap-server-rw

# execute LDAP command to check for configuration mode
ansible-playbook execute_LDAP_Command_Playbook.yml -e ldap_cmd_type=checkConfigMode -e payload=LDAP_Application.yml -e @${INVDIR}/group_vars/ldap-all -e @${INVDIR}/group_vars/ldap-server-rw