.globl freq
.globl inp_symb_cnt
.globl inp_symb_ptr
.globl inp_freq_ptr

.text

freq:
	# Given an array of N words, find the frequency of each word
	# $a0: number of words in the array (N)
	# $a1: address of an array of words
	
#	la $a1, Array
#	li $a0, 9
	
	move $t0, $a0
	move $t1, $a1
	
	li $v0, 9
	sll $a0, $t0, 2
	syscall
	move $t2, $v0
	li $v0, 9
	syscall
	move $t3, $v0
	
	sw $t2, inp_symb_ptr
	sw $t3, inp_freq_ptr
	
	li $t4, 0 # loop iterator
	li $t5, -1 # different symbol count
	li $t6, -1 # last symbol
	li $t7, 0 # freq of last symbol
	freq_loop:
		sll $t8, $t4, 2
		add $t8, $t8, $t1
		lw $t9, ($t8)
		beq $t6, $t9, freq_inc
		
		move $t6, $t9
		addi $t5, $t5, 1
		sll $t8, $t5, 2
		add $t8, $t8, $t2
		sw $t6, ($t8)
		li $t7, 0
		
		freq_inc:
		addi $t7, $t7, 1
		sll $t8, $t5, 2
		add $t8, $t8, $t3
		sw $t7, ($t8)
		
		addi $t4, $t4, 1
	bne $t4, $t0, freq_loop
	
	addi $t5, $t5, 1
	sw $t5, inp_symb_cnt
	jr $ra

.data
	inp_symb_cnt: .space 4
	inp_symb_ptr: .space 4 
	inp_freq_ptr: .space 4
#	Array: .word 1, 1, 1, 2, 3, 4, 4, 5, 5