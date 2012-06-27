.globl main

.text
main:
#	jal encoder
	li $a0, 6
	la $a1, d1
	la $a2, d2
	jal sort
		
	li $v0, 10
	syscall


.data
d1: .word 10, 70, 60, 30, 90, 20
d2: .word 11, 77, 66, 33, 99, 22
