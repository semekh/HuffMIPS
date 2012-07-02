.globl main

.text
main:
	jal encoder
	li $v0, 10
	syscall

