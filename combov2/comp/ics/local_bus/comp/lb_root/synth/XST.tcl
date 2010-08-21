# Precision.tcl: Precision tcl script to compile specified module
# Copyright (C) 2006 CESNET
# Author: Viktor Pus <pus@liberouter.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.
# 3. Neither the name of the Company nor the names of its contributors
#    may be used to endorse or promote products derived from this
#    software without specific prior written permission.
#
# This software is provided ``as is'', and any express or implied
# warranties, including, but not limited to, the implied warranties of
# merchantability and fitness for a particular purpose are disclaimed.
# In no event shall the company or contributors be liable for any
# direct, indirect, incidental, special, exemplary, or consequential
# damages (including, but not limited to, procurement of substitute
# goods or services; loss of use, data, or profits; or business
# interruption) however caused and on any theory of liability, whether
# in contract, strict liability, or tort (including negligence or
# otherwise) arising in any way out of the use of this software, even
# if advised of the possibility of such damage.
#
# $Id$
#

# specify vhdl_design directory
set ROOT            "../../../../../.."
set FIRMWARE_BASE   $ROOT
set COMP_BASE       "$ROOT/comp"

set LB_ROOT_BASE       ".."

# synthesis variables
# (MODULE must be set to the name of toplevel component)
set SYNTH_FLAGS(MODULE) "lb_root"
set SYNTH_FLAGS(OUTPUT) "lb_root"
set SYNTH_FLAGS(FPGA)   "xc2vp50"
#set SYNTH_FLAGS(FPGA)   "xc5vlx110"

# list of sub-components
set COMPONENTS [list  [list "LB_ROOT"   $LB_ROOT_BASE    "FULL"]]


set HIERARCHY(COMPONENTS)  $COMPONENTS
#set HIERARCHY(TOP_LEVEL)   "top_level.vhd"

proc SetTopAttribConstr { } {
   set CONSTR [list \
                  "BEGIN MODEL \"cb_endpoint_top\"" \
                  "NET \"IB_CLK\" PERIOD = 200MHz HIGH 50%;" \
                  "END;"\
   ]
   return $CONSTR
}

# Run global precision tcl script to include general functions
source $ROOT/build/XST.inc.tcl

# In fact, XST tcl script only generates XST script named XST.xst.
SynthesizeProject SYNTH_FLAGS HIERARCHY

# Now Makefile will call 'xst -ifn XST.xst' to perform the synthesis.