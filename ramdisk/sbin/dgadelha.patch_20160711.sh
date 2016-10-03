#!/system/bin/sh

# System Patch via Kernel (20160711)
# Author: Douglas Gadêlha <douglas@gadeco.com.br>
# Version: 20160923
#
# The MIT License (MIT)
#
# Copyright (c) 2016 Douglas Gadêlha. All Rights Reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# You can't disable System Patches, they're an alternative for system.img updates

log -p i -t patches "20160711: Initializing"

if [ ! -d "/data/dgadelha" ]; then
	log -p i -t dgadelha "Creating /data/dgadelha"
	mkdir /data/dgadelha
	chown system:system /data/dgadelha
	chmod 0775 /data/dgadelha
fi

if [ -f "/data/dgadelha/patch_20160711" ]; then
	log -p i -t patches "20160711: /data/dgadelha/patch_20160711 was found, patch may be already applied! Exiting..."
	exit
fi

if [ -d "/patches/20160711" ]; then
	log -p i -t patches "20160711: Patch directory found, verifying for files..."

	if [ -f "/patches/20160711/power.clovertrail.so" ]; then
		log -p i -t patches "20160711: /patches/20160711/power.clovertrail.so found, checking if patch is already applied..."

		if [ -f "/system/lib/hw/power.redhookbay.so" ]; then
			log -p i -t patches "20160711: Re-mounting System as Read-Write (just to make sure)..."
			mount -o remount,rw /system

			log -p i -t patches "20160711: Removing previous files..."
			rm /system/lib/hw/power.redhookbay.so

			log -p i -t patches "20160711: Copying new files..."
			cp /patches/20160711/power.clovertrail.so /system/lib/hw/power.clovertrail.so
			echo "1" > /data/dgadelha/patch_20160711

			log -p i -t patches "20160711: Re-inforcing permissions of modified files..."
			chown system:system /system/lib/hw/power.clovertrail.so
			chown system:system /data/dgadelha/patch_20160711
			chmod 0644 /system/lib/hw/power.clovertrail.so
			chmod 0644 /data/dgadelha/patch_20160711

			log -p i -t patches "20160711: Installed. You may need to reboot to apply the changes"
		else
			log -p i -t patches "20160711: /system/lib/hw/power.redhookbay.so was not found, patch may be already applied!"
		fi
	else
		log -p i -t patches "20160711: /patches/20160711/power.clovertrail.so was not found!"
	fi
else
	log -p i -t patches "20160711: /patches/20160711 was not found!"
fi

log -p i -t patches "20160711: Finished. Exiting..."
