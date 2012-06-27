.globl encoder
.globl enc_inp_ptr
#.globl main
.text
encoder:
main:
	# impl:
	# read_input()
	# n = v0
	# encoder_input_ptr = v1
	# freq(n, encoder_input_ptr)

	jal read_input
	jr $ra

read_input:
	li $v0, 5
	syscall
	add $t0, $v0, $zero
	li $v0, 9
	sll $a0, $t0, 2
	syscall
	sw $v0, enc_inp_ptr
	add $a0, $v0, $zero
	li $v0, 8
	li $a1, 5
	loop:
		syscall
		addi $t1, $t1, 1
		addi $a0, $a0, 4
	bne $t0, $t1, loop
	jr $ra	
	
.data
enc_inp_ptr:
	.space 4
str:
	.space 100
