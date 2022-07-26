#!/bin/bash


function printHelp(){
  echo "parameters:";
  echo " -n <INT> amount of lines to print, default 10";
  echo " -d <INT> amount of subdirectory levels tested, default 1";
  echo " -f find the biggest file instead of directory, default false";
  echo " -h print this help";
  exit
}

# defaults
LINES=15;
DIR="./";
DEEP=1;
FILE=false

#### Parse args
args=("$@")
for ((i=0; i<${#args[@]}; i++)); do
  case ${args[i]} in
    -h|--help)
      printHelp
      exit;
    ;;

    #Amount of lines to print
    -n)
      ((i+=1))
      e=$((i+1))
      number=${!e}

      re='^[0-9]+$'
      if  [[ $number =~ $re ]] ; then
         LINES=$number
      fi
    continue;
    ;;

    #Amount fo subfolders to look into
    -d)
      ((i+=1))
      e=$((i+1))

      number=${!e}

      re='^[0-9]+$'
      if  [[ $number =~ $re ]] ; then
         DEEP=$number
      fi

    continue;
    ;;

    -f)
      FILE=true
    ;;
  esac

  parameter="${args[i]}";
  if [ ! "${parameter:0:1}" == "-" ]; then
    DIR=${args[i]};
  fi
done

#### Execute
if [ $FILE = true ] ; then
  find "$DIR" -maxdepth $DEEP -type f -printf '%s  %p\n' | numfmt --field=1 --to=iec --suffix=B --padding=8  | sort -r -h | head -n $LINES
else
  du -h --max-depth $DEEP "$DIR" | sort -h -r | head -n $LINES
fi











