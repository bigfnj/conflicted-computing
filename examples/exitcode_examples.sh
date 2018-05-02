# Returns a color code depending on exitstatus
function exit_color ()
{
  local status="$?"
  local status_color=""
  if [ $status != 0 ]; then
    status_color=${BIRed}${NC}
  else
    status_color=${BIGreen}{NC}
  fi
}


# Returns smiley or sad face depending on exitstatus
function exit_status()
{
    if [[ $? == 0 ]]; then
        echo -e "\e[1;92m:)\e[m"
    else
        echo -e "\e[1;31m:(\e[m"
    fi
}
