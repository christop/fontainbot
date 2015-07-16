#!/bin/bash


  TMPDIR=.
   TMPID=$TMPDIR/TMP$RANDOM


# --------------------------------------------------------------------------- #
# GET TWITTER MENTIONS
# --------------------------------------------------------------------------- #

   PROJECTROOT=`readlink -f $0   | # ABSOLUTE PATH
                rev              | # REVERT
                cut -d "/" -f 2- | # REMOVE FIRST FIELD
                rev`               # REVERT
   cd $PROJECTROOT
   BSHS=`ls *.sh | egrep "letterset|letterset"`

# --------------------------------------------------------------------------- #
# GET TWITTER MENTIONS
# --------------------------------------------------------------------------- #
# twurl /1.1/statuses/mentions_timeline.json > ${TMPID}.timeline.txt

# --------------------------------------------------------------------------- #
# CHECK MENTIONS AND DO WHATEVER IS NECESSARY
# --------------------------------------------------------------------------- #
# for MENTION in `cat ${TMPID}.timeline.txt             | #
  for MENTION in `cat EDIT/150716_mentionstimeline.json | #
                  sed 's/{"created_at/\n{"created_at/g' | #
                  sed 's/{"created_at/\n{"created_at/g' | #
                  sed 's/ /XXX/g'`
   do
      MENTION=`echo $MENTION | sed 's/XXX/ /g'`
      TWXT=`echo $MENTION | sed 's/","/\n/g' | grep '^text"'`
      TWID=`echo $MENTION | sed 's/","/\n/g' | grep '^id":' | head -n 1`
      TWTO=`echo $MENTION | sed 's/","/\n/g' | grep '^screen_name"'`

      TWXT=`echo $TWXT                             | # DISPLAY TEXT
            cut -d ":" -f 2-                       | # SELECT FIELD 2
            sed 's/^"//'                           | # REMOVE FIRST QUOTE
            sed 's/"$//'                           | # REMOVE LAST QUOTE
            tee`

      if [ `echo "$TWXT"                           | #
            grep "^@fontainbot:"                   | #
            wc -l` -gt 0 ];then                      #

            TWTO=`echo $TWTO                       | #
                  cut -d ":" -f 2                  | #
                  cut -d "\"" -f 2`                  #
            TWID=`echo $TWID                       | #
                  cut -d ":" -f 2                  | #
                   cut -d "," -f 1`                  #
            TWXT=`echo $TWXT                       | #
                  cut -d ":" -f 2-                 | #
                  sed 's/^[ \t]*//'`                 # REMOVE LEADING BLANKS
            
            echo  "$TWXT"                             | # START
            sed 's/\\\//\//g'                         | # UNDO JSON ESCAPES
            sed 's/\\\"/"/g'                          | # UNDO JSON ESCAPES
            sed 's/ )/)/g'                            | # REMOVE WRONG SPACE
            sed 's,http:\\\\/\\\\/t.co\\\\/.*",,g'    | # REMOVE IMAGE URL
            tee > ${TMPID}.txt

            echo "TIME:   "`date "+%d.%m.%Y %T"`      
            TRIGGERTHIS=`echo $BSHS     | #
                         sed 's/ /\n/g' | #
                         shuf -n 1`
            echo "SCRIPT: "`basename $TRIGGERTHIS`

            ./150710_letterset.sh $TWTO $TWID ${TMPID}.txt

            rm ${TMPID}.*  # CLEAN UP
            echo "----------------------------"
      fi
  done

# --------------------------------------------------------------------------- #
# FINITO
# --------------------------------------------------------------------------- #
  cd - > /dev/null 2>&1
  echo


exit 0;