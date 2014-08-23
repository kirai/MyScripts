#!/bin/bash
# I use this to rename pics before uploading to my blog
j=0;for i in `ls *jpg`;do echo mv $i "newname${j}.jpg"; j=$((j+1));done
