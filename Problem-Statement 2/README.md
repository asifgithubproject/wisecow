                                                                       Problem-Statement 2: (1)

# Create a file in the following path.
vi /usr/local/bin/health_monitor.sh

# Make sure that the file has executable permission.
chmod 744 /usr/local/bin/health_monitor.sh

# Make a logs dir in the following path.
mkdir /home/ubuntu/logs

# Switch to / dir and follow the below steps for automating the script. 
cd /

mkdir automated-scripts

cd automated-scripts

crontab -e

*/5 * * * * /usr/local/health_monitor.sh >> /home/ubuntu/logs/system_health.log 2>&1



