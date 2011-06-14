setMode -bs
setCable -port auto
Identify 
identifyMPM 
assignFile -p 1 -file "xilinx-spa3e-xc3s500e.bit"
Program -p 1 -v -defaultVersion 0 
quit
