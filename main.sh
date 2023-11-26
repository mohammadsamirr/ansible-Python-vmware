#!/bin/bash

echo ""
echo "*********************************************************"
echo "*                                                       *"
echo "*            Please select a Playbook                   *"
echo "*                                                       *"
echo "*********************************************************"
cd /ansible/
echo ""
echo "1  - Check facts of a system"
echo "2  - Change ROOT Password"
echo "3  - Reboot a Server"
echo "4  - Run a COMMAND as ROOT user"
echo "5  - Add New User"
echo "6  - Delete a User"
echo "7  - Register to satellite (katello)"
echo "8  - Create Linux Team User Accounts"
echo "9  - Install/Configure ESET Security Tool"
echo "10 - List VM information from vCenter"
echo "11 - Patch(Update) this might REBOOT! the group of hosts you choose"
echo "12 - Take Snapshot of VMs on vCenter"
echo "13 - Remove Snapshot of VMs on vCenter"
echo "14 - Deploy a Virtual Machine on vCenter"
echo "15 - Power Off a Virtual Machine on vCenter"
echo "16 - Power On a Virtual Machine on vCenter"
echo "17 - Pull a list of all VMs from vCenter (Dynamic Inventory)"
echo ""
echo -n "Choose a play to run : "

read -e CHOICE

[ $CHOICE -eq 1 ] && DESCRIPTION="Check facts of a system"
[ $CHOICE -eq 2 ] && DESCRIPTION="Change ROOT Password"
[ $CHOICE -eq 3 ] && DESCRIPTION="Reboot a Server"
[ $CHOICE -eq 4 ] && DESCRIPTION="Run a COMMAND as ROOT user"
[ $CHOICE -eq 5 ] && DESCRIPTION="Add New User"
[ $CHOICE -eq 6 ] && DESCRIPTION="Delete a User"
[ $CHOICE -eq 7 ] && DESCRIPTION="Register to Satellite (katello)"
[ $CHOICE -eq 8 ] && DESCRIPTION="Create Linux Team User Accounts"
[ $CHOICE -eq 9 ] && DESCRIPTION="Install/Configure ESET Security Tool"
[ $CHOICE -eq 10 ] && DESCRIPTION="List VM information from vCenter"
[ $CHOICE -eq 11 ] && DESCRIPTION="System Patch(update)       this might REBOOT! the group of hosts you pick!"
[ $CHOICE -eq 12 ] && DESCRIPTION="Take Snapshot of VMs on vCenter"
[ $CHOICE -eq 13 ] && DESCRIPTION="Remove Snapshot of VMs on vCenter"
[ $CHOICE -eq 14 ] && DESCRIPTION="Deploy a Virtual Machine on vCenter"
[ $CHOICE -eq 15 ] && DESCRIPTION="Power Off a Virtual Machine on vCenter"
[ $CHOICE -eq 16 ] && DESCRIPTION="Power On a Virtual Machine on vCenter"
[ $CHOICE -eq 17 ] && DESCRIPTION="Pull a list of all VMs from vCenter (Dynamic Inventory)"


if [[ $CHOICE == '10' ]]; then

   sudo ansible-playbook vmware/vm_info/vm_info.yml
   exit 1

elif [[ $CHOICE == '12' ]]; then

   sudo ansible-playbook vmware/vm_snapshot/vm_snapshot_create.yml
   exit 1

elif [[ $CHOICE == '13' ]]; then

   sudo ansible-playbook vmware/vm_snapshot_remove/vm_snapshot_remove.yml
   exit 1

elif [[ $CHOICE == '14' ]]; then

   sudo ansible-playbook vmware/vm_create/create_vm.yml
   exit 1

elif [[ $CHOICE == '15' ]]; then

   sudo ansible-playbook vmware/vm_start_stop/vm_stop.yml
   exit 1

elif [[ $CHOICE == '16' ]]; then

   sudo ansible-playbook vmware/vm_start_stop/vm_start.yml
   exit 1

elif [[ $CHOICE == '17' ]]; then

   cat vmware/vmware_dynamic_inventory/read.me
   exit 1
fi


echo ""
echo "*********************************************************"
echo "*                                                       *"
echo "*            Please select a Hostlist                   *"
echo "*                                                       *"
echo "*********************************************************"
echo ""
echo "1 - Ansible group"
echo "2 - Individual Hostname or Ip address"
echo "3 - File with list of hosts"
echo ""
echo -n "Select any below option to run playbook : "
read -e HOSTLIST_OPTIONS

if [[ $HOSTLIST_OPTIONS == '1' ]]; then
   echo ""
   echo "Enter Ansible Group name"
   echo ""
   read -e GROUP
   echo ""
   echo "DO you want to Check server list for Ansible group "$GROUP" ? (y/n)"
   read -e LISTCHK
   if [ $LISTCHK == y ];then
   sudo ansible-inventory --graph $GROUP
   fi
elif [[ $HOSTLIST_OPTIONS == '2' ]]; then
   echo ""
   echo "Enter a Hostname or Ip Adress"
   echo ""
   read -e Hostname_IP
elif [[ $HOSTLIST_OPTIONS == '3' ]]; then
   echo ""
   echo "Enter the Filename with full path which contains list of Hosts"
   echo ""
   read -e Filename
fi
echo ""
echo "*********************************************************"
echo "*                                                       *"
echo "*         Confirm Playbook and Hostlist Details         *"
echo "*                                                       *"
echo "*********************************************************"
echo ""
echo "Playbook description: **$DESCRIPTION**"
echo "Ansible Group or Hostname or IP Address or Filename : **"$GROUP""$Hostname_IP""$Filename"**"
echo ""
echo "Is this correct? (y/n)"
read -e CORRECT

[[ $CORRECT != y ]] && exit 0

[ $CHOICE -eq 1 ] && PLAY=playbooks/main_playbooks/main.facts.yml
[ $CHOICE -eq 2 ] && PLAY=playbooks/main_playbooks/main.root.yml
[ $CHOICE -eq 3 ] && PLAY=playbooks/main_playbooks/main.reboot.yml
[ $CHOICE -eq 4 ] && PLAY=playbooks/main_playbooks/main.rootcmd.yml
[ $CHOICE -eq 5 ] && PLAY=playbooks/main_playbooks/main.useradd.yml
[ $CHOICE -eq 6 ] && PLAY=playbooks/main_playbooks/main.userdel.yml
[ $CHOICE -eq 7 ] && PLAY=playbooks/main_playbooks/main.rhn_sat.yml
[ $CHOICE -eq 8 ] && PLAY=playbooks/main_playbooks/main.linuxusers.yml
[ $CHOICE -eq 9 ] && PLAY=playbooks/main_playbooks/main.esetagent.yml
[ $CHOICE -eq 10 ] && PLAY=vmware/vm_info/vm_info.yml
[ $CHOICE -eq 11 ] && PLAY=playbooks/patching/katello_non_prod.yml
[ $CHOICE -eq 12 ] && PLAY=vmware/vm_snapshot/vm_snapshot_create.yml
[ $CHOICE -eq 13 ] && PLAY=vmware/vm_snapshot_remove/vm_snapshot_remove.yml



echo ""
echo "*********************************************************"
echo "*                                                       *"
echo "*              Initiating Playbook                      *"
echo "*                                                       *"
echo "*********************************************************"
echo ""
echo "Running Playbook '$PLAY' against $GROUP $Hostname_IP $Filename"
echo ""

#################################################
if [[ $HOSTLIST_OPTIONS == '1' ]]; then

   sudo ansible-playbook -l $GROUP $PLAY

elif [[ $HOSTLIST_OPTIONS == '2' ]]; then

   sudo ansible-playbook -i "$Hostname_IP," $PLAY

elif [[ $HOSTLIST_OPTIONS == '3' ]]; then

   sudo ansible-playbook -i "$Filename" $PLAY

fi
