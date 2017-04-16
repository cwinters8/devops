# To describe all instances with a Purpose=test tag

# Command:

aws ec2 describe-instances --filters "Name=tag:Name,Values=ansible-control" | grep InstanceId | cut -d '"' -f4

aws ec2 start-instances i-0c5773867164538d4

alias startansctl=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=ansible-control" | grep InstanceId | cut -d '"' -f4)

# TO-DO: CREATE ANSIBLE PLAYBOOK TO START/STOP INSTANCE(S)!