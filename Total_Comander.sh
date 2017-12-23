#!/bin/bash
#$INP = 0

can_use_as_dir() {
   $(cd "$*" >/dev/null 2>/dev/null)
   echo "$?"
   #echo "$?" '''|| [ cd "$*" -r ] || [ cd "$*" -x ]'''

   #$(cd "$*"	>/dev/null 2>/dev/null)
	#echo "$?"
   #if [[ $( "$*" -r) = 1 || $("$*" -d) =1]];
      #echo "$?"
}

get_mime_type() {
   file --mime-type -b "$*" 2>/dev/null
}

min() {
   echo $((${1}<${2}?${1}:${2}))
}

max() {
   echo $((${1}>${2}?${1}:${2}))
}

START_POSITION=0
CURRENT=0
while echo -e -n "\033[0;32m\]":
do
  read -s -n 1 INP
  clear
  COUNT=$(ls -1a | wc -l)
  COLUMNS=1 #$(min 1 ${COUNT})
  readarray FILES <  <(ls -1a)

  if [ "$INP" = "q" ]; then
    echo ""
    break
  fi
  if [ "$INP" = "s" ]; then
    CURRENT=$(min ${CURRENT}+1 ${COUNT}-1)
    echo $CURRENT
  fi
  if [ "$INP" = "w" ]; then
    CURRENT=$(max 0 ${CURRENT}-1)
    echo $CURRENT

  fi
  if [ "$INP" = "x" ]; then
    if [[ $(can_use_as_dir ${FILES[${CURRENT}]}) = 0 ]]; then
       DIRECTORY=${FILES[${CURRENT}]}
       cd "$(echo $DIRECTORY)"
       CURRENT=0
       COUNT=$(ls -l -a | wc -l)
       COLUMNS=1 #All output  
       readarray FILES <  <(ls -1 -a)
    elif [[ $(get_mime_type ${FILES[${CURRENT}]}) = "text/x-shellscript" ]]; then
       less ${FILES[${CURRENT}]}
    elif [[ $(get_mime_type ${FILES[${CURRENT}]}) = "text/*" ]]; then
       ./${FILES[${CURRENT}]}
       echo "shell script has been executed press anykey to continue"
       read -s -n 1 INP
       clear
    fi
  fi

for ((i = $((${CURRENT}+${COLUMNS} > ${COUNT}?${COUNT}-${COLUMNS}:${CURRENT})); i < $(min $((${CURRENT}+${COLUMNS})) ${COUNT}); i++))
do
   if [ $i = "$CURRENT" ]; then
      echo -e -n "\033[0;96m\]"
   fi
   echo ${FILES[i]}
   echo -e -n "\033[0;96m\]"
   
done
echo "-------------"
done
