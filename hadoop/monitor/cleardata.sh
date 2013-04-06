#!/bin/bash
# author: Zhou Haihan
# web: http://abloz.com
# date: 2012.8.22
# email: ablozhou@gmail.com

# Simple Monitor for Processes

# Provided as-is; use at your own risk; no warranty; no promises; enjoy!
# Copyright (c) 2013-2015 by Andy Zhou.

# to rm data/fail*
param=$1
if [ $# -eq 0 ]; then
   param="fail" 
fi

case $param in
    "all")
        echo "clear all data msgs"
        rm data/*
        ;;
    "fail")
        echo "clear fail count"
        rm data/fail*
        ;;
    "total")
        echo "clear total count"
        rm data/total*
        ;;

    *)
        echo "clear param of $1"
        if [ -f $1 ]; then 
            rm $1
        fi
        ;;
    esac

