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
Adding a admin user and removing the guest login is recommended (replace username and password with your own preferred config):
```
rabbitmqctl add_user username password
rabbitmqctl set_user_tags username administrator
rabbitmqctl set_permissions -p / username ".*" ".*" ".*"
```

## Install ruby on Raspberry Pi

Install rbenv by using the following commands on your pi. (if you're using zsh change .bashrc to .zshrc)
```
sudo apt-get install rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> .bashrc
echo 'eval "$(rbenv init -)"' >> .bashrc
```
Confirm installation:
```
rbenv -v
```
Install git:
```
sudo apt-get install git
```
Install ruby-build(used to get available ruby-versions):
```
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```
Install ruby version 3.2.0 and set it as global version (or local if you have other instances already)
```
rbenv install 3.2.0
rbenv global 3.2.0
```
Install all gems required for the project
```
gem install bundler
bundle install
```

## Running as publisher
To start the service as publisher use the following command:
```
ruby run.rb -p
```
Some additional flags are needed to specify which sensors you are using, if you are using
a non-local rabbitMQ instance run the following to get info on how to configure:
```
ruby run.rb -h
```
Example on external host with lightsensor on standard port and dht active:
```
ruby run.rb -p -H hostaddress -q queuename -P password -U username --use-dht --use-lightsensor
```

### Using and setting up Temp/Humidity sensor DHT-11/22
1. connect the dht module to your Pi according to the instructions given by your supplier.
1. edit /boot/config on your Raspberry Pi
1. add `dtoverlay=dht11` or `dtoverlay=dht22` at the bottom
1. when running program add the -D or --use-dht flag.

### Using and setting up a LightSensor
1. connect the light sensor module to your Pi according to the instructions given by your supplier.
1. when running program add the -L or --use-lightsensor flag.
1. specify GPIO port by adding the flag -l or --light-sensor-pin followed by pin number.
1. adjust the potentiometer to match the threshold of ambient light you consider a sunny day.


## Available flags
Usage: run.rb [options]
```
    -p, --publisher                  Run as publisher
    -U, --user=USER                  Set username
    -P, --password=PASSWORD          Set password for user
    -m, --mockPi                     Run as mock-Pi, i.e. not using actual sensors
    -D, --use-dht                    Activate DHT-11/22 sensor
    -l, --use-lightsensor            Activate lightsensor
    -L, --lightsensor-pin=SENSORPIN  Set light-sensor-pin, default 3
    -u, --update-rate=UPDATERATE     Set update-rate of publisher thread
    -q, --queue-name=QUEUENAME       Set queue name
    -H, --host=HOST                  Set rabbit-mq host url
    -t, --ttl=TTL                    Set TTL (seconds) of messages on queue
    -h, --help                       Prints this help
```
