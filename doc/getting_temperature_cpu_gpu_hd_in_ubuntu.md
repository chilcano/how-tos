## Getting temperature of CPU and HD in Ubuntu with Psensor


- https://itsfoss.com/check-laptop-cpu-temperature-ubuntu/
- https://www.tecmint.com/monitor-cpu-and-gpu-temperature-in-ubuntu/
- https://unix.stackexchange.com/questions/328906/find-fan-speed-and-cpu-temp-in-linux

Requeriments:
```sh
$ sudo apt install -y lm-sensors hddtemp
```

Then start the detection of your hardware sensors:
```sh
$ sudo sensors-detect
```

To make sure that it works, run the command below:
```sh
$ sensors

If everything seems alright, proceed with the installation of Psensor by using the command below:

```sh
$ sudo apt install -y psensor
```

Once installed, run the application by looking for it in the Unity Dash.

xxx



On the first run, you should configure which stats you want to collect with Psensor.

yyyy

If you want to show the temperature in the top panel, go to Sensor Preferences:

yyyyyyy

Then under the Application Indicator menu, select the component for which you want to display the temperature and then check the Display sensor in the label option.
