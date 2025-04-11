#!/bin/bash

cp gnomeInstall.sh setup.sh ~
if [ $? -ne 0 ]; then
    echo "Error: Failed to copy gnomeInstall.sh and setup.sh to the home directory."
fi
