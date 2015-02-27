import RPi.GPIO as GPIO
import sys

redPin = int(sys.argv[1])
greenPin = int(sys.argv[2])

color = sys.argv[3]

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(redPin, GPIO.OUT)
GPIO.setup(greenPin, GPIO.OUT)

if color == "green":
	GPIO.output(redPin, False)
	GPIO.output(greenPin, True)
elif color == "red":
	GPIO.output(redPin, True)
	GPIO.output(greenPin, False)
elif color == "yellow":
	GPIO.output(redPin, True)
	GPIO.output(greenPin, True)
else:
	GPIO.output(redPin, False)
	GPIO.output(greenPin, False)

