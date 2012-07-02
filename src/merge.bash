#!/bin/bash
echo "" >encoder.asm
for i in encoder/*.asm
do
	cat $i >>encoder.asm
done;

cp decoder/decoder.asm ./
