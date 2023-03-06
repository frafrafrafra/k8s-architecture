
echo "Setup ssh configuration"
sed -i 's/.*ClientAliveInterval.*/ClientAliveInterval 1800/' /etc/ssh/sshd_config
systemctl restart ssh