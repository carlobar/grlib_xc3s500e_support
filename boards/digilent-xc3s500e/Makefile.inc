# Since synplify seems to cause a synthsis error involving
# the DSP macro blocks the Spartan 3A technology 
# without DSP is used for synthesis
#
TECHNOLOGY=Spartan3E
ISETECH="Spartan3E"
PART=XC3S500E
PACKAGE=fg320
SPEED=-5
SYNFREQ=140
PROMGENPAR=-x xcf04s -u 0 $(TOP).bit -p mcs -w -o xilinx-spa3e-xc3s500e

MANUFACTURER=Xilinx
MGCPART=XC3S500E$(PACKAGE)
MGCTECHNOLOGY=SPARTAN3E
MGCPACKAGE=$(PACKAGE)
