.globl freq
.text
freq:
	# Given an array of N words, find the frequency of each word
	# $a0: number of words in the array (N)
	# $a1: address of an array of words
	# $v0: address of an array, $v0[i] = frequency($a1[i])
	jr $ra
