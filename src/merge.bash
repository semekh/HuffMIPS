#!/bin/bash
echo "" >../all.asm
for i in *.asm
do
	cat $i >>../all.asm
done;
