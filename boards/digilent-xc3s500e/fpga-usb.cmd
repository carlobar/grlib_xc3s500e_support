setMode -bscan
setCable -p usb21
identify
assignfile -p 1 -file xilinx-spa3e-xc3s500e.bit
program -p 1 -e -v
quit

