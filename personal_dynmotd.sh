#!/bin/bash
# COPY TO /etc/profile.d/

# Variables
SYSname=`hostname -s`
SYSuptime=`uptime | sed 's/.*up \([^,]*\), .*/\1/'`
SYSif=`hostname -I`
SYSmem=`free -m | grep ^Mem: | awk '{printf("%s MB Total -- %s MB Free",$2,$4)}'`

# #####NOT IN USE VARIABLES
# SYSrel=`uname -r`
# SYScpucount=`cat /proc/cpuinfo | grep ^processor | wc -l`
# SYScpu=`cat /proc/cpuinfo | grep ^"model name" | head -n 1 | awk '{out=""; for(i=4;i<=NF;i++){out=out$i" "}; print out}'`

SYSaccount=`whoami`
SYSusers=`who | awk '{print $1}' | sort | uniq | sed '$!N;s/\n/ /'`

# Display user name in red if user is root as a reminder to be careful
if [ $(id -u) -eq 0 ];
then
  SYSme="\033[1;37m\033[41m===> root <===\033[0m"
else
  SYSme="\033[1;32m$SYSaccount\033[0m"
fi

# Determine system type from installed software
# OpenVPN
if [ -d /etc/openvpn ]; then
  SYSserver="VPN Server"
fi

echo -e "\033[1;32m"
figlet -t -f standard $SYSname
echo -e "
   \033[0;31m   BigFNj Security Warning:

   \033[1;30m	This system is intended for non business purposes.
	Follow Your Dreams,
	You Can Reach Your Goals...
	I'm Living Proof.
	Beefcake!
	BEEFCAKE!!

\033[0;35m+++++++++++++++++: \033[0;37mSystem Data\033[0;35m :+++++++++++++++++++
\033[0;35m+    \033[0;37mHostname \033[0;35m= \033[1;32m$SYSname
\033[0;35m+  \033[0;37mAddress(s) \033[0;35m= \033[1;32m$SYSif
\033[0;35m+      \033[0;37mMemory \033[0;35m= \033[1;32m$SYSmem
\033[0;35m+      \033[0;37mUptime \033[0;35m= \033[1;32m$SYSuptime
\033[0;35m+ \033[0;37mFilesystems \033[0;35m= \033[1;32m
\033[0;35m+ \033[1;32m  %Free Total(MB)  Used(MB)  Free(MB) Filesystem
\033[0;35m+ \033[1;32m=======  ========  ========  ======== ===========
`df -mP | grep -v Filesystem | grep -v "tmpfs" | grep -v /proc | awk '{printf("\033[0;35m+ \033[1;32m%6.2f%% %9s %9s %9s %-s \033[0m\n",$4/$2*100,$2,$3,$4,$6)}'`
\033[0;35m++++++++++++++++++: \033[0;37mUser Data\033[0;35m :++++++++++++++++++++
\033[0;35m+    \033[0;37mUsername \033[0;35m= $SYSme
\033[0;35m+       \033[0;37mUsers \033[0;35m= \033[1;32m$SYSusers\033[0m
"

# #####NOT IN USE VARIABLES
# \033[0;35m+++++++++++: \033[0;37mMaintenance Information\033[0;35m :+++++++++++++
# \033[0;31m`cat /etc/motd-maint`
# \033[0m

# \033[0;35m+     \033[0;37mKernel \033[0;35m= \033[1;32m$SYSrel

# \033[0;35m+        \033[0;37mCPU \033[0;35m= \033[1;32m$SYScpucount CPUs, $SYScpu
