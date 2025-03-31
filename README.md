# ARM-assembly-button-LED
Program for Tiva C TM4C123GXL board, turns on and off LED with button-push user interaction.

# ***Summary***

The program takes in the user input (pressing the button) and outputs the light from the blue and green LEDs combining to make cyan light; when the user stops pressing the button, the light turns off. The lights and buttons are programmed through connected GPIOs (general-purpose input and output pins) on pins F2, F3 and F4, along with a programmed pull-up resistor to regulate the signal when not engaged. All of the connections are enabled via manipulation of the system control registers, which means the program runs at a very low-level and cost on the machine.
