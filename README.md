# octopus_software_dfu
Script and wire to reset a BTT Octopus via the Raspberry PI GPIO pins and flash klipper on it

## Required parts
- 3x wires
- 5x dupont connector
- 1x schotky diode such as 1N5817
- 1x capacitor roughly between 1 µF to 100 µF (altough you could probably get away with 0.1 uF)

## The reset wire
We're using the TFT reset line on the BTT Octopus to reset the board. This pin needs to be pulled-down. In order to avoid driving the NRST pin high, we use a low forward voltage diode.




