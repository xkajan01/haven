# Precision.tcl: Precision tcl script to compile specified module
# Copyright (C) 2007 CESNET
# Author: Jiri Tobola <tobola@liberouter.org>
#         Lukas Solanka <solanka@liberouter.org>
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
set FIRMWARE_BASE  "../../../../.."
set BASE           "$FIRMWARE_BASE"

set TOP_LEVEL_ENT $env(TOP_LEVEL_ENT)

# synthesis variables
set SYNTH_FLAGS(MODULE) $TOP_LEVEL_ENT
set SYNTH_FLAGS(OUTPUT) $TOP_LEVEL_ENT
set SYNTH_FLAGS(FPGA)   "xc5vlx155t-2"

# list of sub-components
set COMPONENTS [list  [list $TOP_LEVEL_ENT   ".."   "FULL"]]

set MODULES "fl_watch_4.vhd fl_watch_2.vhd fl_watch_4_hdr.vhd fl_watch_2_hdr.vhd"

set HIERARCHY(COMPONENTS)  $COMPONENTS
set HIERARCHY(TOP_LEVEL)     $MODULES

proc SetTopAttribConstr { } {
    # create clock - define desired period..
	create_clock -period 5 CLK
   set_attribute -design rtl -name NOPAD -value TRUE -port {*}
}
#
# run global precision tcl script to synthesize module design
puts "Running global precision tcl script"
source $BASE/build/Precision.inc.tcl

SynthesizeProject SYNTH_FLAGS HIERARCHY
