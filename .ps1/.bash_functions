#------------------------------------------------
# Add some system level functions
#------------------------------------------------
# my_ps     #Current User Process
# my_pp     #Current User Process forked Mapping
# killps    #Kill Process by Name
# my_ip     #Get IP adress on via hostname -I
# mydf      #Pretty print of df output in 'ii'
# ii        #Get current host related info
#------------------------------------------------

function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }

function my_pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }

function killps()   # kill by process name
{
    local pid pname sig="-TERM"   # default signal
    if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
        echo "Usage: killps [-SIGNAL] pattern"
        return;
    fi
    if [ $# = 2 ]; then sig=$1 ; fi
    for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} )
    do
        pname=$(my_ps | awk '$1~var { print $5 }' var=$pid )
        if ask "Kill process $pid <$pname> with signal $sig?"
            then kill $sig $pid
        fi
    done
}


function my_ip() # Get IP adress on ethernet.
{
    /bin/hostname -I
}


function mydf()
{
    for fs ; do

        if [ ! -d $fs ]
        then
          echo -e $fs" :No such file or directory" ; continue
        fi

        local info=( $(command df -P $fs | awk 'END{ print $2,$3,$5 }') )
        local free=( $(command df -Ph --block-size=M $fs | awk 'END{ print $4 }') )
        local nbstars=$(( 20 * ${info[1]} / ${info[0]} ))
        local out="["
        for ((j=0;j<20;j++)); do
            if [ ${j} -lt ${nbstars} ]; then
               out+="*"
            else
               out+="-"
            fi
        done
        local used=${info[2]}
        local pct="$(printf '%4s' $used)"
        free="$(printf '%9s' $free)"
        out+="] "$free" free on "$fs
        pct+="$out"
        echo "$pct"
    done
}


function ii()   # Get current host related info.
{
    echo -e "\nYou are logged on ${BRed}$HOSTNAME"
    echo -e "\n${BRed}Additionnal kernel information:$NC " ; uname -a
    echo -e "\n${BRed}Release  information:$NC " ; sh ~/scripts/function_linux_release.sh
    echo -e "\n${BRed}Java in use by system:$NC " ; java -version
    echo -e "\n${BRed}Users logged on:$NC " ; who | cut -d " " -f1 | sort | uniq
    echo -e "\n${BRed}Current date :$NC " ; date
    echo -e "\n${BRed}Machine stats :$NC " ; uptime
    echo -e "\n${BRed}Memory stats :$NC " ; free -m | grep ^Mem: | awk '{total=$2;used=$3-$6-$7;free=total-used} END {printf("%7'"'"'d MB Total\n%7'"'"'d MB Used\n%7'"'"'d MB Free",total,used,free)}' 
    echo -e "\n\n${BRed}Diskspace :$NC " ; mydf `df -x tmpfs -x devtmpfs -hP | grep -v Filesystem | awk '{ print $6 }'` 
    echo -e "\n${BRed}Local IP Address :$NC" ; my_ip
    echo
}


#-------------------------------------------------------------------------
# File & strings related functions:
#-------------------------------------------------------------------------
# ff        #Find a file with a pattern in name
# fe        #Find a file with a pattern $1 in the name & execute $2 on it
# fstr      #Find a pattern in a set of files & highlight them
# swap      #Swap 2 filenames around, if they exist
#-------------------------------------------------------------------------
# Find a file with a pattern in name:
function ff() {
  find . -type f -iname '*'"$*"'*' -ls 2>/dev/null
}

# Find a file with pattern $1 in name and Execute $2 on it:
function fe() { find . -type f -iname '*'"${1:-}"'*' \
-exec ${2:-file} {} \;  ; }

#  Find a pattern in a set of files and highlight them:
#+ (needs a recent version of egrep).
function fstr()
{
    OPTIND=1
    local mycase=""
    local usage="fstr: find string in files.
Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
    while getopts :it opt
    do
        case "$opt" in
           i) mycase="-i " ;;
           *) echo "$usage"; return ;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    find . -type f -name "${2:-*}" -print0 | \
xargs -0 egrep --color=always -sn ${case} "$1" 2>&- | more

}


function swap()
{ # Swap 2 filenames around, if they exist
    local TMPFILE=tmp.$$

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}


#------------------------------------------------------------
# Misc utilities:
# Repeat    # Repeat n times command
# Ask       # See 'killps' for example of use
# List EXE  # List all files or directories with the +x flag
# List TREE # List all directories in tree structure
# Extract   # Extracts files without having to recall syntax
# Split CSV # Splits a CSV on a line maintaining headers
#------------------------------------------------------------

function repeat()       # Repeat n times command.
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}


function ask()          # See 'killps' for example of use.
{
    echo -n "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}


function lexe()           # List all files or directories with the +x flag
{
for i in `ls -l | awk '{ if ( $1 ~ /x/ ) {print $NF}}'`; do echo `pwd`/$i; done
}


function ltree
{
    ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/';
}


function extract ()
{
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}


function splitcsv ()    # splitcsv <Filename> [chunkSize/split on line number]
{
    HEADER=$(head -1 $1)
    if [ -n "$2" ]; then
        CHUNK=$2
    else
        CHUNK=1000
    fi
    tail -n +2 $1 | split -l $CHUNK - $1_split_
    for i in $1_split_*; do
        echo -e "$HEADER\n$(cat $i)" > $i
    done
}


#---
#END
#---


#-------------------------------------
# Function to run upon exit of shell.
function _exit()
{
    echo -e "${BWhite}${On_Red}Hasta la vista, baby${NC}"
}
trap _exit EXIT
