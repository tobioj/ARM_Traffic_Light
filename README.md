## Traffic Light System using ARM Assembly on Raspberry Pi 4 ##
- School : UNBC
- Student: Oluwatobi Ojulari
- Student ID: 230150319

## Introduction ##
This project demonstrates a traffic light system implemented in ARM assembly language on a Raspberry Pi 4. It utilizes the Raspberry Pi’s GPIO pins to control six LED bulbs representing the three colors of a standard traffic light: red, amber and green. The system simulates realistic traffic light behavior by sequencing the LEDs with appropriate time delays.

## Code Overview ##
The program is structured into sections responsible for different aspects of the system:

## GPIO Pin Assignment ##
1. GPIO pins 15, 16, 17, 21, 22 and 23 are used:
- Red LEDs: 15, 21
- Amber LEDs: 16, 22
- Green LEDs: 17, 23
- Pins are configured for output mode via the GPIO_MODES register.

2. Memory Mapping
- GPIO registers are mapped to main memory locations to allow direct access.
- Function registers are established for each of the six LEDs.

3. Traffic Light Sequence
- A predefined loop controls the on/off sequence of the LEDs.
- Each color has a set time delay simulating the typical traffic light timing.

## Memory Addresses and GPIO Configuration ##
The code defines memory addresses for GPIO peripherals: GPSETO0, GPCLR0, GPFSEL1 and GPFSEL2

- These addresses are used to:

* Configure GPIO pins

* Control output states of the LEDs

## Conclusion ##
This traffic light system demonstrates how ARM assembly language can be used to interact with hardware on the Raspberry Pi 4. The project provides a practical example of embedded system programming, hardware interfacing and GPIO control using assembly language.

## Compilation and Execution ##
as -o traffic_light.o traffic_light.s
gcc -o traffic_light traffic_light.o
./traffic_light
