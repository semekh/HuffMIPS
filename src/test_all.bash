#!/bin/bash
./merge.bash

for i in tests/*.in; 
do
	echo -e "\033[1;34mRunning test $i\033[0m"
	cat $i | ./run.bash encoder.asm >tmp.enc
	cat tmp.enc | ./run.bash decoder.asm >tmp.dec
	tail -1 $i >tmp.in
	diff tmp.in tmp.dec -wB
	if [ $? == 0 ]; then
		echo -e "\033[1;32mCorrect\033[0m"
		pre=`tail -1 $i | wc -c`
		enc=`tail -1 tmp.enc | wc -c`
		((rat=(pre-enc) * 100 / pre))
		echo -e "Input String Size: \033[1;33m$pre\033[0m bytes"
		echo -e "Encoded String Size: \033[1;33m$enc\033[0m bytes"
		echo -e "Compression Ration: \033[1;33m%$rat\033[0m"
	else
		echo -e "\033[1;31mIncorrect\033[0m"
	fi
	echo "-------------";
	rm tmp.*
done;
