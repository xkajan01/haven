#
# Modules.tcl: Local include tcl script
# Copyright (C) 2008 CESNET
# Author(s): Pavol Korcek <korcek@liberouter.org>
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

# -----------------------------------------------------------------------------

# Base directories
set FIRMWARE_BASE  "$ENTITY_BASE/../../../../../../.."

if { $ARCHGRP == "FULL" } {

  set COMPONENTS [list \
         [list "BASE"          $ENTITY_BASE/../base   "FULL"] \
         [list "ALIGN_UNIT"    $FIRMWARE_BASE/comp/gics/internal_bus/comp/base/align_unit "FULL"] \
	]

  # completition constants (for rx_align_unit)
  set MOD "$MOD $FIRMWARE_BASE/comp/ics/internal_bus/pkg/ib_pkg.vhd"
  # optional align unit
  set MOD "$MOD $ENTITY_BASE/rx_align_unit.vhd"
  # whole ib_generator
	set MOD "$MOD $ENTITY_BASE/ib_generator.vhd"
}

