# Raspberry Pi Site monitor

A dual colour LED-based website monitor for the Raspberry Pi. 

Using red+green 3-pin LEDs, you can create 3 colours: red, green, and yellow. These work well for status indication, so they are a good choice for a website monitor.

There's a bit of python in here that deals with the Raspberry PI's General Purpose In/Out (GPIO) pins, which drives the LEDs. The rest is dealt with through a Bash script.

The bash script first pings a hostname (such as example.com). If it doesn't respond to ping, it will turn the LED to red. If it does respond to ping, it will use curl to determine the HTTP status of a given page on the website. If this status is 200 or 204, it will turn the LED to green. If the HTTP status is anything else, yellow.

If you're better at reading pseudo code instead of text:

```
if (site responds to ping):
  if (page http status is 200 or 204):
    LED color = green
  else:
    LED color = yellow
else:
  LED color = red
```

## Requirements

- Hardware:
  - A Raspberry pi set up with networking
  - Some red+green dual color LEDs (or just a red and green LED per site)
  - NPN transistors to drive the LEDs
  - Some resistors (I used 2x 1k Ohm + 2x 220 Ohm per dual colour LED)
- Software:
  - Python
  - Python RPi.GPIO
  - Curl

---

## Usage

Clone or download the repository, wire up the electronics. In a terminal on your RPi, go to the directory with this code, and run:

```
sudo ./monitor
```

If that doesn't work (probably if you've downloaded this a zip), make `monitor` executable:

```
chmod +x monitor
```

and try running it again. It won't produce any output, and will keep running until you hit Ctrl-C.

To see the status is of the things you're testing, run it with `-v` or `-vv` for more detail:

```
sudo ./monitor -v
```

Once you are satisfied your setup works, you can edit `monitor` with your favourite text editor to configure which sites are monitored, and which GPIO pins are used. You can add as many sites(and LEDs) as you have GPIO pins for.

## To do

See [Issues](https://github.com/michd/rpi-site-monitor/issues) on GitHub.
