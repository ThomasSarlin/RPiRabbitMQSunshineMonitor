# RPiRabbitMQSunshineMonitor
Simple Raspberry pi light-sensor implementation which adds sunshine messages onto a rabbitMQ queue to be consumed.

## Install RabbitMQ on Pi
Install:
```
sudo apt-get install rabbitmq-server
```
Start on boot
```
sudo systemctl enable rabbitmq-server
```
Start now
```
sudo systemctl start rabbitmq-server
```
Install web-based management interface (if you want to be able to monitor your rabbitmq instance)
```
sudo rabbitmq-plugins enable rabbitmq_management
```
I recommend adding an admin user and removing the guest login by running the following commands (replace username and password with your own preferred config):

```
rabbitmqctl add_user username password
rabbitmqctl set_user_tags username administrator
rabbitmqctl set_permissions -p / username ".*" ".*" ".*"
```

### Using and setting up Temp/Humidity sensor DHT-11/22
1. edit /boot/config on your Raspberry Pi
1. add `dtoverlay=dht11` or `dtoverlay=dht22` at the bottom
1. when running program add the --use-dht flag.


