#!/bin/bash
root="/source/freeflare/server/php/web/"

WEB_DIR=$root"Presentation/Web/Temp"
MIS_DIR=$root"Presentation/Mis/Temp"
WAP_DIR=$root"Presentation/Wap/Temp"
DEV_DIR=$root"Presentation/Dev/Temp"
CRM_DIR=$root"Presentation/Crm/Temp"

rm -rf $WEB_DIR/*
rm -rf $MIS_DIR/*
rm -rf $WAP_DIR/*
rm -rf $DEV_DIR/*
rm -rf $CRM_DIR/*
