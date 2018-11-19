#!/bin/bash
#
#   Copyright (c) 2014-2018 Eaton
#
#   This file is part of the Eaton $BIOS project.
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License along
#   with this program; if not, write to the Free Software Foundation, Inc.,
#   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
#! \file    setup-nut-users-ExecStartPre.sh
#  \brief   Script to create NUT users before starting NUT
#  \author  Jean-Baptiste Boric <JeanBaptisteBoric@Eaton.com>
#

# Set up a NUT administrator
if [ ! -f /etc/default/bios-nut-admin ]
then
    nut_bios_user=bios-administrator
    nut_bios_password=$(dd if=/dev/urandom count=1 bs=16 2>/dev/null | md5sum | cut -f1 -d' ')
    echo "Creating NUT internal user $nut_bios_user..."

    # Add user to NUT configuration
    cat <<EOF >>/etc/nut/upsd.users

[$nut_bios_user]
    password = $nut_bios_password
    actions = SET
    instcmds = ALL

EOF

    # Store credentials in a environment variable file
    touch /etc/default/bios-nut-admin
    chmod 660 /etc/default/bios-nut-admin
    chown bios /etc/default/bios-nut-admin
    cat <<EOF >/etc/default/bios-nut-admin
NUT_USER="$nut_bios_user"
NUT_PASSWD="$nut_bios_password"
EOF
fi
