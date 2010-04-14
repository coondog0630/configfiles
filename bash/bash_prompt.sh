#!/bin/bash
#  flex - a prompt with nearly everything ...
#    - user set-able colours and date format
#    - load display (loads above one only, displayed in 
#      the upper right corner)
#    - history number, directory, username, hostname
#    - terminal number and clock in the upper right corner
#    - if you're in "screen," it will let you know
#    - if you have apm, the status of your battery will be 
#      displayed
#    - the info in the upper right corner can be set to 
#      auto-refresh

# Look past the colour list to set your own prompt colours and options

#  Notes:
#  ------
#  - to clean up previous autorefreshes:
#       jobs -l | grep callPrintInfo | awk '{print $2}'
#  - could make a lot of stuff user settable as variables,
#    like date format (done) ...
#  - evidently CHANGING LINES in a tput cursor relocate 
#    is BAD - this is why I have two separate functions 
#    setting up the two lines of the upper right corner.  
#    Without this, long command lines are butchered.

ResetColours="$(tput sgr0)"
Black="$(tput setaf 0)"
BlackBG="$(tput setab 0)"
DarkGrey="$(tput bold ; tput setaf 0)"
LightGrey="$(tput setaf 7)"
LightGreyBG="$(tput setab 7)"
White="$(tput bold ; tput setaf 7)"

Red="$(tput setaf 1)"
RedBG="$(tput setab 1)"
LightRed="$(tput bold ; tput setaf 1)"
Green="$(tput setaf 2)"
GreenBG="$(tput setab 2)"
LightGreen="$(tput bold ; tput setaf 2)"
Brown="$(tput setaf 3)"
BrownBG="$(tput setab 3)"
Yellow="$(tput bold ; tput setaf 3)"
Blue="$(tput setaf 4)"
BlueBG="$(tput setab 4)"
BrightBlue="$(tput bold ; tput setaf 4)"
Purple="$(tput setaf 5)"
PurpleBG="$(tput setab 5)"
Pink="$(tput bold ; tput setaf 5)"
Cyan="$(tput setaf 6)"
CyanBG="$(tput setab 6)"
BrightCyan="$(tput bold ; tput setaf 6)"

##################################################
#
#   User Settings
#
##################################################

# Set User Chosen Colours Here:

UC1="${BrightBlue}"   # brackets, parentheses, separators
UC2="${LightGrey}"     # text
UC3="${Yellow}"    # final "$" or "#"
UC4="${White}"   # upper right text colour
UC5="${BlueBG}" # upper right background colour
UNC="${BrightRed}" # display username "root" in this colour

WC1="${LightGreen}"  # Warning colour for low load
WC2="${Yellow}"  #Medium Load
WC3="${Red}"     #High Load

# Do you want the autorefresh upper right information?
# (this is a weird feature and I'm not sure I recommend
# it, although it seems to mostly work ...)
#refresh="0" # Yes
refresh="1" # No
let refreshRate=30  # Time in seconds between refreshes

#  Date Format:
#  see "man date" for format details, uncomment the one you like
dateFMT='%H%M'  # I prefer this: 24 hour with no colon
#dateFMT='%I:%M' # 12 hour with colon
#dateFMT='%r'    # 12 hour time with seconds, colon separators, and AM/PM

##################################################
#
#   End User Settings
#
##################################################

# Now that we've picked our colours, unset the originals:
unset Black BlackBG DarkGrey LightGrey LightGreyBG White \
      Red RedBG LightRed Green GreenBG LightGreen \
		Brown BrownBG Yellow Blue BlueBG BrightBlue \
		Purple PurpleBG Pink Cyan CyanBG BrightCyan

#  If user is root, UNC (user name colour) is whatever they set it as
#  in colour settings, otherwise it should be set to the "text" colour
if [ "$(whoami)" != "root" ]
then
	UNC="${UC2}"
fi

##################################################
#
#   Set some (One-time) Useful Variables
#
##################################################

HAVE_APM="$(which apm 2> /dev/null > /dev/null ; echo $?)"

temp="$(tty)"
cur_tty="${temp:5}"
unset temp
if [ "${TERM}" = "screen" ]
then
	#   We're using the "screen" program
	SCR="[*SCR*]"
	if [ "$(echo ${STY}) | grep pts" != "" ]
	then
		#   We're in X (I think)
		Xyes=0
	fi
else
	SCR=""
fi

function prompt_command {
	
	##################################################
	#
	#   Compute the Battery Condition (if it applies)
	#
	##################################################

	if [ ${HAVE_APM} -eq 0 ]
	then
		#  As much of the response of the "apm" command as is necessary 
		#  to identify the given condition:
		NO_BATT_MESG="no system battery"
		BATT_MESG="battery status"
		NO_AC_MESG="AC off"
		AC_MESG="AC on"

		APMD_RESPONSE="$(apm)"
		case $temp in                                                  
			*${AC_MESG}*)                                                
				ACstat="^"
				;;
			*${NO_AC_MESG}*)
				ACstat="v"
				;;
		esac

		case $APMD_RESPONSE in
			*${NO_BATT_MESG}*)
				BATTERY=""
				;;
			*${BATT_MESG}*)
				local temp="$(apm)"
				battery="${temp##* }"
				BATTERY="eval \\\[${LightBlue}\\\][\\\[${White}\\\]\\\$ACstat\\\$battery]\\\[${LightBlue}\\\]"
				;;
		esac
	fi
}

function ur1 {
	##################################################
	#
	#   Set up the Upper Right Text
	#
	##################################################

	#  the command whose output is written in the upper right corner:
	topRight="echo -n ${cur_tty} $(date +${dateFMT})"
	#  prompt_x is where to position the cursor to write the topRight info:
	let prompt_x=$(($(tput cols)-$(${topRight} | wc -c)))

	#  save cursor position:
	tput sc
	tput cup 0 ${prompt_x}
	#  set up the colours:
	echo -n "${UC4}${UC5}"
	${topRight}
	tput rc
}

function ur2 {
	##################################################
	#
	#   Set up the Upper Right Load Display
	#
	##################################################

	local prompt_x="$(($(tput cols)-2))" # x position on screen
	local DC="" # Display Colour
	local temp="$(cat /proc/loadavg)"
	local load="${temp%% *}"
	local load100=$(echo -e "scale=0 \n ${load}/0.01 \n quit \n" | bc)
	local output='\253\273'
	if [ "$load100" -gt "250" ]
	then
		# very high load: show the numeric value in WC3
		DC="${WC3}"
		output="${load}"
		prompt_x="$(($(tput cols)-$(echo -n "${output}" | wc -c)))"
	elif [ "$load100" -gt "200" ]
	then
		# high load - WC3
		DC="${WC3}"
	elif [ "$load100" -gt "150" ]
	then
		# medium load - WC2
		DC="${WC2}"
	elif [ "$load100" -gt "100" ]
	then
		# light load - WC1
		DC="${WC1}"
	else
		# blank
		output="  "
	fi
	#  print the output:
	tput sc
	tput cup 1 ${prompt_x}
	echo -en "${ResetColours}"
	echo -en "${DC}"
	echo -en "${output}"
	echo -en "${ResetColours}"
	#  restore cursor position:
	tput rc
}

function callPrintInfo {
while [ 0 ]
do
   #   PROCESS STATE CODES (for "ps" command)
   #     D   uninterruptible sleep (usually IO)
   #     R   runnable (on run queue)
   #     S   sleeping
   #     T   traced or stopped
   #     Z   a defunct ("zombie") process
   #  "ps T" seemed like a better idea, but it's hard to check its output!
   if [ "$(ps ax | grep ${cur_tty} | grep -v grep | grep -v "ps ax" | grep -v -- -bash | grep -v " T ")" = "" ]
   then
      ur1 ; ur2
   fi
   sleep ${refreshRate}
done
}


PROMPT_COMMAND=prompt_command

function flex {

TITLEBAR="\[\033]1;\u@\h\007\033]2;${SCR}\u@\h:${cur_tty}:\w\007\]"
case $TERM in
	xterm*|rxvt*)
		echo -n ""  # nop
		;;
	screen*)
		if [ "${Xyes}" -ne "0" ]
		then
			TITLEBAR=""
		fi
		;;
	*)
		TITLEBAR=""
		;;
esac

PS1="${TITLEBAR}\
\[${UC1}\]${BATTERY}${SCR}[\[${UC2}\]\!\[${UC1}\]|\
\[${UC2}\]\${PWD}\[${UC1}\]]\n\
\[${UC1}\][\[${UNC}\]\
\u\[${UC1}\]@\[${UC2}\]\h\[${UC1}\]]\
\[\$(ur1)\]\[\$(ur2)\]\
\[${UC3}\]\$\[${ResetColours}\] " 

PS2="\[${UC1}\]--\[${ResetColours}\] "

}

if [ "${refresh}" -eq "0" ]
then
	callPrintInfo &
else
	unset callPrintInfo
fi
