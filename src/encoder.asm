.globl encoder
.globl enc_inp_len
.globl enc_inp_ptr

.text

encoder:
	jal read_input
	jal build
#	jal output
	
	li $v0, 10
	syscall

build:

	addi $sp, $sp, 12
	sw $ra,  0($sp)
	sw $s0,  4($sp)
	sw $s1,  8($sp)
	
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

	li $s1, 1 # loop iterator
	enc_build_tree:
		jal heap_extract_min
		move $s2, $v0
		move $s3, $v1
		jal heap_extract_min
		add $s2, $s2, $v0
		move $a0, $s3
		move $a1, $v1
				
		#jal huff3_merge
		li $v0, 1
		syscall
		li $v0, 1
		move $a0, $a1
		syscall
		
		move $a0, $s2
		add $a1, $s0, $s1
		addi $a1, $a1, -1
		jal heap_insert
				
		addi $s1, $s1, 1
	bne $s1, $s0, enc_build_tree


#	for i = 0 to n
#		insert to heap
#	for i = 0 to n
#		ext i1, v1
#		ext i2, v2
#		merge bs(v1), bs(v2)
	
	lw $ra,  0($sp)
	lw $s0,  4($sp)
	lw $s1,  8($sp)
	addi $sp, $sp, -12
	jr $ra

read_input:
	li $v0, 5
	syscall
	add $t0, $v0, $zero
	sw $t0, enc_inp_len
	
	sll $a0, $t0, 2 #FIXME: should be added by 1 char
	li $v0, 9
	syscall
	add $a0, $v0, $zero
	sw $a0, enc_inp_ptr
	li $v0, 8
	sll $a1, $t0, 2
	addi $a1, $a1, 1
	syscall
	
	jr $ra

.data
enc_inp_len: .space 4
enc_inp_ptr: .space 4
