# Modules.tcl: Local include Modules tcl script
# Copyright (C) 2007 CESNET
# Author: Lukas Solanka <solanka@liberouter.org>
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

set COMP_BASE       "$ENTITY_BASE/../../../.."
set FIFO_BASE       "$COMP_BASE/base/fifo/fifo"
#set SH_FIFO_BASE    "$COMP_BASE/base/fifo/sh_fifo"

set FIFO        "FULL"
#set SH_FIFO     "FULL"


# Source files for all architectures
set PACKAGES "$PACKAGES $COMP_BASE/ics/local_bus/pkg/lb_pkg.vhd"
set PACKAGES "$PACKAGES $COMP_BASE/base/pkg/math_pack.vhd"

set COMPONENTS [list \
        [list "FIFO"    $FIFO_BASE      $FIFO]      \
    ]

set MOD "$ENTITY_BASE/lb16_8_ios_bridge.vhd"
set MOD "$MOD $ENTITY_BASE/lb8_16_ios_bridge.vhd"
