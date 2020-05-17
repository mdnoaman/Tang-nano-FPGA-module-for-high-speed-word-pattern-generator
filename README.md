# Tang-nano-FPGA-module-for-high-speed-word-pattern-generator
An extemely low cost (5 euros) nano Tang FPGA board is configured to perform very high speed word pattern generator.

The FPGA board (https://github.com/sipeed/Tang-Nano-Doc) comes with a dedicated USB JTAG programmer which also serves the purpose of transfer of data using UART configuration. 

With the configuration done here, the FPGA reads a byte stream from a PC over UART and saves the data in the block SRAM. The baudrate is set to 1000000 bps which can altered if the need be. I have used a PLL to clock the FPGA at 100 MHz. 


The default setting of the software (and the hardware) does not allow for the UART communication. It needs following steps to set this up.
1. in the Gowin designer window go to Project >> configuration. This will open a window (titled configuration)
2. press "Dual-Purpose Pin". This should show you a bunch a check box options.
3. check mark the "use DONE as regular IO" and "use RECONFIG_N as regular IO" boxes

The job is not done yet!!



