sudo yum update -y && sudo yum install -y python-pip && sudo pip install ansible && sudo yum install -y git
git clone https://github.com/simplytunde/tutorial.git
cd tutorial/pipeline1/ansible
ansible-playbook playbooks/install_locally.yml -i inventories/calendarapp.yml
