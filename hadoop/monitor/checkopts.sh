#!/bin/bash
# author: Zhou Haihan
# web: http://abloz.com
# date: 2012.8.22
# email: ablozhou@gmail.com

# Simple Monitor for Hadoop Processes, Memory and Diskspace usage. 

# Provided as-is; use at your own risk; no warranty; no promises; enjoy!
# Copyright (c) 2013-2015 by Andy Zhou.


FAILCOUNT=9999
echo "checkopts:$@"
OPTIND=1
chkopts() {
  while getopts "am:c:t:f:s:" optname
    do
      case "$optname" in

        "a")
          echo "Option $optname is specified"
          ;;
        "c")
            COUNTFILE=$OPTARG
          ;;
        "m")
            MSGFILE=$OPTARG
          ;;
        "t")
          echo "Option $optname has value ${OPTARG}"
            TITLE="${OPTARG}"
            echo "TITLE=$TITLE"
          ;;
        "s")
          echo "Option $optname has value ${OPTARG}"
            SENDCOUNTFILE=${OPTARG}
          ;;
        "f")
          echo "Option $optname has value ${OPTARG}"
            FAILCOUNT=${OPTARG}
         ;;
        "?")
          echo "Unknown option $OPTARG"
          ;;
        ":")
          echo "No argument value for option $OPTARG"
          ;;
        *)
          # Should not occur
          echo "Unknown error while processing options"
          ;;
      esac
    done
  return $OPTIND
}

showargs () {
  for p in "$@"
    do
      echo "[$p]"
    done
}
chkopts "$@"
