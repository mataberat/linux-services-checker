PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

##list your services you want to check
SERVICES=( 'hhvm' )

#### OK. STOP EDITING ####


 for i in "${SERVICES[@]}"
  do
 ###CHECK SERVICE####
 `pgrep $i >/dev/null 2>&1`
 STATS=$(echo $?)

 ###IF SERVICE IS NOT RUNNING####
 if [[  $STATS == 1  ]]

  then
  ##TRY TO RESTART THAT SERVICE###
  service $i start

  ##CHECK IF RESTART WORKED###
  `pgrep $i >/dev/null 2>&1`
  RESTART=$(echo $?)

  if [[  $RESTART == 0  ]]
   ##IF SERVICE HAS BEEN RESTARTED###
   then

    ##REMOVE THE TMP FILE IF EXISTS###
    if [ -f "/tmp/$i" ]; 
    then
     rm /tmp/$i
    fi

    ##SEND AN EMAIL###
    curl -s --user 'your api key' \
    https://api.mailgun.net/v3/user/messages \
    -F from='youruser@email.com' \
    -F to=user@user.com \
    -F subject='[Success] Down at - Has been started' \
    -F text='Your success text.'

   else
    ##IF RESTART DID NOT WORK###

    ##CHECK IF THERE IS NOT A TMP FILE###
    if [ ! -f "/tmp/$i" ]; then

     ##CREATE A TMP FILE###
     touch /tmp/$i

     ##SEND A DIFFERENT EMAIL###
    curl -s --user 'your api key' \
    https://api.mailgun.net/v3/user/messages \
    -F from='youruser@email.com' \
    -F to=user@user.com \
    -F subject='[Failed] Down at - Can not started' \
    -F text='Your failed text'
    fi
  fi
 fi



  done
exit 0;

