# RMS Record Management System


## Rms.trm

The rms.trm file contains the configuration for the terminal model. It has the ability to handle keys that send multiple charactors, i.e. ANSI terminals.

How the LEAD-IN/LEAD-OUT works:

Imagine a function key that sends 0x01 U 0x0D. We are interested in the 'U' because it will be the keypress for Update.

The lead-in sequence will be 0x01 and then 0x00 to terminate the sequence. The lead-out will be 0x0D and then 0x00 to terminate. RMS looks for the lead-in sequence, pushes the next byte on stack (the 'U') and then looks for the lead-out. If the sequence isn't found then the bell is rung.

Then the app checks second byte in key sequences for CR, BS, etc.
