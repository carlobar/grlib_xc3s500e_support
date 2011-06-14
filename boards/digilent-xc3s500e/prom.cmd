setMode -bs
setCable -port auto
Identify 
assignFile -p 1 -file "xilinx-spa3e-xc3s500e.mcs"
setAttribute -position 1 -attr packageName -value "(null)"
Program -p 1 -v -defaultVersion 0 
quit
