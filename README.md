# Object-Detecting-Ultrasonic-Radar
Real-time object detection system built with Arduino, an HC-SR04 ultrasonic sensor, and servo scanning, with serial data visualization in Processing.

## How It Works

The servo motor continuously sweeps the ultrasonic sensor from 15° to 165° and then back again.

At each angle:

1. The Arduino moves the servo to the current position.
2. The HC-SR04 sends an ultrasonic pulse.
3. The Arduino measures how long the reflected pulse takes to return.
4. The travel time is converted into distance using the speed of sound.
5. The Arduino sends the angle and distance to the computer using serial communication.
6. The Processing program reads the data and displays the detection on a graphical radar interface.

The distance calculation is based on:

`distance = duration × 0.034 / 2`

The division by 2 is required because the sound travels from the sensor to the object and then back to the sensor.

The Arduino sends data in the following format:

`angle,distance.`

Example:

`90,25.`

This represents an object detected approximately 25 cm away at an angle of 90°.

## Radar Visualization

The Processing application receives the serial data and converts each servo angle into a direction on the screen.

The interface includes:

- A green semicircular radar grid
- A real-time green scanning line
- Fading red lines representing detected objects
- Current servo angle
- Current measured distance
- Object detection status

Objects that occupy multiple neighboring angles appear as a larger red region on the radar.

## Parts List

- Arduino Uno R3
- HC-SR04 ultrasonic distance sensor
- SG90 servo motor
- Breadboard
- Male-to-male jumper wires
- USB cable
- Computer running Arduino IDE
- Processing IDE

## Pin Connections

| Component | Arduino Pin |
| --- | --- |
| Servo Signal | D12 |
| HC-SR04 TRIG | D10 |
| HC-SR04 ECHO | D11 |
| Servo VCC | 5V |
| Servo GND | GND |
| HC-SR04 VCC | 5V |
| HC-SR04 GND | GND |

## Software

### Arduino

The Arduino program:

- Controls the servo sweep
- Triggers the ultrasonic sensor
- Measures echo duration
- Calculates distance
- Sends angle and distance data over serial communication

### Processing

The Processing program:

- Reads serial data from the Arduino
- Parses the angle and distance values
- Converts the polar measurement into screen coordinates
- Draws the radar grid and scanning line
- Stores recent detections to create a fading red detection effect

## Serial Communication

The Arduino and Processing application communicate at:

`9600 baud`

Both programs must use the same baud rate.

The Arduino Serial Monitor should be closed before starting the Processing program because only one application can normally use the Arduino COM port at a time.

## What I Learned

This project helped me develop experience with:

- Arduino programming
- Servo motor control
- Ultrasonic distance measurement
- Serial communication
- Timing using microseconds
- Basic sensor integration
- Processing graphics
- Polar-to-Cartesian coordinate conversion
- Hardware debugging and breadboard wiring
