#-------------------------------
# Alias Redefinitions "Colorize"
#-------------------------------
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'


#-------------------------------
# Alias Redefinitions "Generic"
#-------------------------------
alias c='clear'                     #clear the screen easily
alias ..='cd ..'                    #Go back 1 directory
alias sudo='sudo '                  #common typo correction
alias wget='wget -c'                #continue on errors
alias tf='tail -250f'               #tail and follow buffering up the last 250 lines
alias mkdir='mkdir -pv'             #create parent directory if required
alias du='du -ach | sort -h'        #make du more readable


#-----------------------------------------------------------------------
# The 'ls' family
# Add colors for filetype and  human-readable sizes by default on 'ls':
#-----------------------------------------------------------------------
alias ls='ls -h --color=tty'        #List with color option
alias lx='ls -lXB'                  #Sort by extension.
alias lk='ls -lSr'                  #Sort by size, biggest last.
alias lt='ls -ltr'                  #Sort by date, most recent last.
alias lc='ls -ltcr'                 #Sort by/show change time,most recent last.
alias lu='ls -ltur'                 #Sort by/show access time,most recent last.
#-----------------------------------------------------------------------
# The ubiquitous 'll': directories first, with alphanumeric sorting:
#-----------------------------------------------------------------------
alias ll='ls -lvh --group-directories-first --color=auto'
alias lm='ll |more'                 #Pipe through 'more'
alias la='ll -Atr'                  #Show hidden files
alias l.='ls -d .* --color=auto'    #list only hidden without directories
alias lah='ll -Ad .* --color=tty'   #list only hidden
alias lr='ll -R'                    #Recursive ls


#-------------------------------------------------
# New or added Functionality to existing commands
#-------------------------------------------------
alias ports='netstat -tulanp'
alias meminfo='free -m -l -t'
alias mount='mount |column -t'
alias now='date +"%T | %m-%d-%Y"'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'     # Pass an argument IE: psg bash


#-------------------------------
# Get top process eating memory
#-------------------------------
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'


#-------------------------------------------
# Alias Pretty-print of some PATH variables
#-------------------------------------------
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'


#uncomment after installing "vim-enhanced"
#alias vi='vim'


#uncomment after moving ccat to /usr/bin and chmod +x on it
#alias cat='ccat'


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# SUDO ALIAS SECTION - REQUIRES SUDO! #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#


#---------------------------------------------
# Shortcut  for iptables and pass it via sudo
#---------------------------------------------
alias ipt='sudo /sbin/iptables'


#---------------------------
# IP Tables - Make Friendly
#---------------------------
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias firewall=iptlist
