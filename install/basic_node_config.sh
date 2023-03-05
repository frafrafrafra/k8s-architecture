
echo "Setup ssh configuration"
sed -i 's/.*ClientAliveInterval.*/ClientAliveInterval 60/' /etc/ssh/sshd_config