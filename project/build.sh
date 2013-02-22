#!/bin/bash
OUTPUT_DIR="output"
PRODUCT_DIR="Buddy"
mkdir -p $OUTPUT_DIR
rm -rf $OUTPUT_DIR/*
mkdir -p $OUTPUT_DIR/$PRODUCT_DIR
cp -r ../php/* $OUTPUT_DIR/$PRODUCT_DIR
cp ./ChangeLog $OUTPUT_DIR/
cp ./releasenotes.txt $OUTPUT_DIR/

cd $OUTPUT_DIR
find ./ -type d -name ".svn"|xargs rm -rf {}
tar zcvf "buddy.tar.gz" $PRODUCT_DIR;
cd ../
rm $OUTPUT_DIR/$PRODUCT_DIR/* -rf;
