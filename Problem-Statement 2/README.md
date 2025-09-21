                                Prerequisites Problem-Statement 2 (1)

# Create a file in the following path.
vi /usr/local/bin/health_monitor.sh

# Make sure that the file has executable permission.
chmod 744 /usr/local/bin/health_monitor.sh

# Make a logs dir in the following path.
mkdir -p /home/ubuntu/logs

# Install the required package
sudo apt install -y sysstat 

# Switch to / dir and follow the below steps for automating the script. 
cd /

mkdir automated-scripts

cd automated-scripts

crontab -e

*/5 * * * * /usr/local/bin/health_monitor.sh >> /home/ubuntu/logs/system_health.log 2>&1


                               Prerequisites Problem-Statement 2 (2)

# Create ssh connection b/w the system server & backup server.

# Create a file in the following path.
vi /home/ubuntu/backup_solution.sh

# Make sure that the file has executable permission.
chmod 744 /home/ubuntu/backup_solution.sh

# Switch to / dir and follow the below steps for automating the script at 2AM everyday.
cd /

mkdir automated-scripts

cd automated-scripts

crontab -e

0 2 * * * /home/ubuntu/backup_solution.sh

# Make directories on the backup-server.
mkdir -p /tmp/other-system-backup              # this dir will store backup

mkdir -p /home/ubuntu/backup-reports           # this dir will store the report
