# Tang-nano-FPGA-module-for-high-speed-word-pattern-generator
An extemely low cost (5 euros) nano Tang FPGA board is configured to perform very high speed word pattern generator. It can generate 16 channel output 1024 states with 32 bit time resolution (10ns).

The FPGA board (https://github.com/sipeed/Tang-Nano-Doc) comes with a dedicated USB JTAG programmer which also serves the purpose of transfer of data using UART configuration. 

With the configuration done here, the FPGA reads a byte stream from a PC over UART (the python script) and saves the data in the block SRAM. The baudrate is set to 1000000 bps which can altered if the need be. I have used a PLL to clock the FPGA at 100 MHz. 


The default setting of the software (and the hardware) does not allow for the UART communication. It needs following steps to set this up.
1. in the Gowin designer window go to Project -> configuration. This will open a window (titled configuration)
2. press "Dual-Purpose Pin". This should show you a bunch a check box options.
3. check mark the "use DONE as regular IO" and "use RECONFIG_N as regular IO" boxes
4. (for this project where I have used 16 output pins, the "SSPI and MSPI" check boxes should also be checked )


The job is not done yet :( (At least in my case, it seems that the firmware needs to be updated)

Now, we need to set the ch552T chip on the nano board into bootloader mode. I have followed this page (https://qiita.com/ciniml/items/05ac7fd2515ceed3f88d) that claims that there are two methods to achieve the goal.

1. By short circuiting the pins 14 an 20 on the 552T chip. However, it could be quite painful task. I could not succeed using this method.
2. Using FT_Prog

Using FT_Prog:
  1. download and install FT_Prog (the version worked for me: ft_prog_v3.0.56.245)
  2. Launch the program and go to "DEVICES" -> "Scan and Parse". This should show the "device tree"
  3. Then "DEVICES" -> "Program". It should open a window which message "Programming Failed". Close the window.
  4. The ch552T chip is now in programmable mode.
  
Now to update the firmware on the ch552T chip, first download the prebuild firmware binary file (https://onedrive.live.com/?authkey=%21ANQSRfghzUvTAi4&cid=68E4D0C39AB81EF8&id=68E4D0C39AB81EF8%21455150&parId=68E4D0C39AB81EF8%21455149&action=locate). Once can also build the file from here (https://github.com/diodep/ch55x_jtag). Then download and install the WCHISP Tool (http://www.wch.cn/download/WCHISPTool_Setup_exe.html) 
1. Launch the program and select "8 Bit CH55X series" tab and select chip model ch552. leave evrything to default.
2. select firmware binary file in the "User File" path.
3. Press "Download". The task should be completed now.
  

