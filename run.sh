#!/usr/bin/env bash
########################################
#  Simple Telegram channel posting script
########################################
#
#  Author: Facundo Montero <facumo.fm@gmail.com>
#
########################################
#
# Depends on: bash 4 or greater.
#
########################################

# Configuration
URLS_PATH="$HOME"'/websites.final'
SPOKEN_NAME='Johnny'

# Functions

function sendMessage
{
 curl -s "https://api.telegram.org/bot""$API_KEY""/sendMessage" -d "{ \"chat_id\":\"$LCID\", \"text\":\"$1\", \"parse_mode\":\"markdown\"}" -H "Content-Type: application/json" 2>&1 > /dev/null
}

function getSite
{
 readarray links < $URLS_PATH
 STATUS='None'
 while [ "$STATUS" != 'Ok' ]
 do
  LINK=${links[ $(( $RANDOM % ${#links[@]} )) ]}
  echo "$SPOKEN_NAME"' is checking the link he found...'
  sendMessage "$SPOKEN_NAME"' is checking the link he found...'
  CURL_TRY=$(curl -w '\n%{time_total}' $LINK -s)
  CURL_STATUS=$?
  RESPONSE_TIME=$(echo "$CURL_TRY" | tail -1)
  if echo "$CURL_TRY" | grep 'renew' 2>&1 > /dev/null
  then
   DOMAIN_REGISTRATION='unregistered'
  fi
  if [ $CURL_STATUS -ne 0 ] || [ "$DOMAIN_REGISTRATION" == 'unregistered' ]
  then
   echo "$SPOKEN_NAME"" found out it's down. No fun for ""$LINK"'. Will now try again...'
   sendMessage "$SPOKEN_NAME"" found out it's down. No fun for ""$LINK"'. Will now try again...'
  else
   STATUS='Ok'
  fi
 done
 echo "$SPOKEN_NAME"' is happy, this one took just '"$RESPONSE_TIME"' seconds to reply.'"
$LINK"
 sendMessage "$SPOKEN_NAME"' is happy, this one took just '"$RESPONSE_TIME"' seconds to reply.'"
$LINK"
 printf "$DATESTR"'Waiting for updates...'
}

# Main

if [ ! -f .api_key ]
then
 echo '".api_key" file not found in current directory ('"$PWD"'), cannot continue.'
 exit 1
else
 API_KEY=$(cat .api_key)
fi
LAST=""
COUNT=0
printf '\n'"$(date '+%d-%m-%y / %H:%M')"': Say hi to '"$SPOKEN_NAME""! I'm up and running.\n"
while true
do
 LAST=$(curl -s "https://api.telegram.org/bot""$API_KEY""/getUpdates" -F offset=$(( $LUID + 1 )))
 LCID=$(echo "$LAST" | tail -1 | sed 's/.*chat":{"id"://g' | cut -d ',' -f 1)
 LMSG=$(echo "$LAST" | sed 's/text/\ntext/' | tail -1 | cut -d '"' -f 3)
 OUTPUT="$OUTPUT""$(date '+%d-%m-%y / %H:%M')"': '
 DATESTR="$OUTPUT"
 LUID=$(echo "$LAST" | grep update_id)
 if [ "$?" -eq 0 ]
 then
  LUID=$(echo "$LUID" | head -1 | cut -d ':' -f 4 | cut -d ',' -f 1)
  printf "$OUTPUT"'Update #'"$(( $LUID + 1 ))"' from chat ID '"$LCID"'.\n'
  case "$LMSG" in
	'/getsite')
	  getSite &
	  ;;
	*)
	  sendMessage 'You reply to '"$SPOKEN_NAME"', you get more fun.' &
	  getSite &
	  ;;
  esac
 fi
 OUTPUT='\n'
 COUNT=$(( $COUNT + 1 ))
 #printf '\rRan '"$COUNT"' times'
done
