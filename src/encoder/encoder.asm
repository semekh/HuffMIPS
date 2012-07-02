.globl encoder
.globl enc_inp_len
.globl enc_inp_ptr
.globl enc_inp_ptr2

.text

encoder:
	jal read_input
	jal build_tree
	lw $a0, enc_inp_ptr2
	lw $a1, enc_inp_len
	jal huff_print_tree
	
	li $v0, 10
	syscall

build_tree:

	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	lw $s0, enc_inp_len
	lw $s1, enc_inp_ptr

	move $a0, $s0
	move $a1, $s1
	move $a2, $s1
	jal sort

	move $a0, $s0
	move $a1, $s1
	jal freq
	
	lw $s0, inp_symb_cnt
	lw $s1, inp_freq_ptr
		
	move $a0, $s0
	jal heap_init
	
	li $s2, 0 # loop iterator
	enc_insert:
		sll $a0, $s2, 2
		add $a0, $a0, $s1
		lw $a0, ($a0)
		move $a1, $s2
		jal heap_insert
		addi $s2, $s2, 1
	bne $s2, $s0, enc_insert

	move $a0, $s0
	jal huff3_init
	
	li $s1, 1 # loop iterator
	enc_build_tree:
		jal heap_extract_min
		move $s2, $v0
		move $s3, $v1
		jal heap_extract_min
		add $s2, $s2, $v0
		move $a0, $s3
		move $a1, $v1
				
		jal huff3_merge
		
		move $a0, $s2
		add $a1, $s0, $s1
		addi $a1, $a1, -1
		jal heap_insert
				
		addi $s1, $s1, 1
	bne $s1, $s0, enc_build_tree

	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20
	jr $ra

read_input:
	li $v0, 5
	syscall
	add $t0, $v0, $zero
	sw $t0, enc_inp_len
	
	##
	sll $a0, $t0, 2
	addi $a0, $a0, 4
	li $v0, 9
	syscall 
	sw $v0, enc_inp_ptr2
	##
	
	sll $a0, $t0, 2
	addi $a0, $a0, 4
	li $v0, 9
	syscall
	add $a0, $v0, $zero
	sw $a0, enc_inp_ptr
	li $v0, 8
	sll $a1, $t0, 2
	addi $a1, $a1, 1
	syscall
	
	##
	lw $t1, enc_inp_ptr2
	lw $t3, enc_inp_ptr
	sll $t2, $t0, 2
	addi $t2, $t2, 4
	add $t2, $t2, $t1
    pkh_loop:
    	lw $t4, 0($t3)
    	sw $t4, 0($t1)
    	addi $t3, $t3, 4
    	addi $t1, $t1, 4
    	bne $t1, $t2, pkh_loop
	##
	
	jr $ra

.data
enc_inp_len: .space 4
enc_inp_ptr: .space 4
enc_inp_ptr2: .space 4
