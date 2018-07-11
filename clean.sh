#!/bin/bash

folder=$(pwd)

rm -fv ${folder}/*.log
rm -fv ${folder}/*.out
rm -fv ${folder}/*.err
rm -fv ${folder}/core.*

tput bold
tput setaf 2
echo "Cleaned."
tput sgr0