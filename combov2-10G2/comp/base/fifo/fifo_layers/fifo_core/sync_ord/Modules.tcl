# Modules.tcl: Local include Leonardo tcl script
# Copyright (C) 2007 CESNET
# Author: Koritak Jan <jenda@liberouter.org>
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
#

# Base directories
set FIRMWARE_BASE     "$ENTITY_BASE/../../../../../.."
set MATH_PACK_BASE    "$FIRMWARE_BASE/comp/base/pkg"
set FIFO_LAYERS_BASE  "$FIRMWARE_BASE/comp/base/fifo/fifo_layers" 

if { $ARCHGRP == "FULL" } {
   set FIFO_MEM_BASE   "$FIFO_LAYERS_BASE/fifo_mem"
   set SYNC_ORD_BASE   "$FIFO_LAYERS_BASE/fifo_core/sync_ord"

# Source files for all components
   set PACKAGES  "$FIFO_LAYERS_BASE/pkg/fifo_pkg.vhd"
	       
   set COMPONENTS [list\
      [list   "MATH_PACK" $MATH_PACK_BASE   "MATH"]\
      [list   "FIFO_MEM"   $FIFO_MEM_BASE   "FULL"]]

   set MOD "$MOD $SYNC_ORD_BASE/fifo_sync_ord_ent.vhd"
   set MOD "$MOD $SYNC_ORD_BASE/fifo_sync_ord.vhd"
}
