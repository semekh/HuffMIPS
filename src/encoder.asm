
.globl bsearch

bsearch:
	li $t0, 0
	lw $t1, inp_symb_cnt
	lw $t8, inp_symb_ptr
	
	bs_loop:
		add $t2, $t0, $t1
		srl $t2, $t2, 1
		
		sll $t9, $t2, 2
		add $t9, $t9, $t8
		lw $t9, 0($t9)
		
		beq $t9, $a0, bs_found
		beq $t0 $t2, bs_not_found
		blt $t9, $a0, bs_right

		bs_left:
		move $t1, $t2		
		b bs_loop

		bs_right:
		move $t0, $t2
		b bs_loop		

	bs_not_found:
	li $t2, -1
	bs_found:
	move $v0, $t2	
	jr $ra

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

.text
.globl heap_init
.globl heap_insert
.globl heap_extract_min

heap_init:
	li $v0, 9
	sll $a0, $a0, 4
	syscall
	sw $v0, Heap_Base
	li $v0, 1
   	sw $v0, Heap_CurrentSize
	jr $ra

heap_insert:
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $ra, 4($sp)
	lw $s0, Heap_Base
	lw $t0, Heap_CurrentSize
	sll $t1, $t0, 3
	add $t1, $t1, $s0
	sw $a0, 0($t1)
	sw $a1, 4($t1)
	addi $t0, $t0, 1
	sw $t0, Heap_CurrentSize
	addi $a0, $t0, -1
	jal Heap_InsertUpdate
	lw $ra, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
	

heap_extract_min:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	lw $s0, Heap_Base
	lw $t0, Heap_CurrentSize
	addi $t0, $t0, -1
	lw $v0, 8($s0)
	lw $v1, 12($s0)
	sll $t1, $t0, 3
	add $t1, $t1, $s0
	lw $t2, 0($t1)
	sw $t2, 8($s0)
	lw $t2, 4($t1)
	sw $t2, 12($s0)
	sw $t0, Heap_CurrentSize
	sw $ra, 4($sp)
	sw $v0, 8($sp)
	sw $v1, 12($sp)
	li $a0, 1
	jal Heap_Update
	lw $v1, 12($sp)
	lw $v0, 8($sp)
	lw $ra, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	jr $ra

Heap_Parrent:
	srl $v0, $a0, 1
	jr $ra
	
Heap_LeftChild:
	sll $v0, $a0, 1
	jr $ra
	
Heap_RightChild:
	sll $v0, $a0, 1
	add $v0, $v0, 1
	jr $ra

Heap_InsertUpdate:
	sll $t0, $a0, 3
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	ble $t0, 8, Heap_IUD_End
	Heap_IUD_Loop:
		add $t1, $s0, $t0
		srl $a0, $t0, 3		
		jal Heap_Parrent
		sll $v0, $v0, 3
		add $t2, $s0, $v0
		lw $t3, 0($t1)
		lw $t4, 0($t2)
		ble $t4, $t3, Heap_IUD_End
		sw $t4, 0($t1)
		sw $t3, 0($t2)
		lw $t3, 4($t1)
		lw $t4, 4($t2)
		sw $t4, 4($t1)
		sw $t3, 4($t2)
		add $t0, $v0, $0
		bgt $t0, 8, Heap_IUD_Loop
	Heap_IUD_End:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
Heap_Update:
	add $v1, $a0, $0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal Heap_LeftChild
	add $t1, $v0, $0
	jal Heap_RightChild
	add $t2, $v0, $0
	ble $t0, $t1, Heap_UD_secondIf
	sll $t3, $a0, 3
	sll $t4, $t1, 3
	add $t3, $s0, $t3
	add $t4, $s0, $t4
	lw $t3, 0($t3)
	lw $t4, 0($t4)
	Heap_UD_firstIf:
		ble $t3, $t4, Heap_UD_secondIf
		add $v1, $t1, $0
	Heap_UD_secondIf:
		ble $t0, $t2, Heap_UD_thirdIf
		sll $t3, $v1, 3
		sll $t4, $t2, 3
		add $t3, $s0, $t3
		add $t4, $s0, $t4
		lw $t3, 0($t3)
		lw $t4, 0($t4)
		ble $t3, $t4, Heap_UD_thirdIf
		add $v1, $t2, $0
	Heap_UD_thirdIf:
		beq $v1, $a0, Heap_UD_End
		sll $t1, $a0, 3
		add $t1, $s0, $t1
		sll $t2, $v1, 3
		add $t2, $s0, $t2
		lw $t3, 0($t1)
		lw $t4, 0($t2)
		sw $t4, 0($t1)
		sw $t3, 0($t2)
		lw $t3, 4($t1)
		lw $t4, 4($t2)
		sw $t4, 4($t1)
		sw $t3, 4($t2)
		add $a0, $v1, $0
		jal Heap_Update
	Heap_UD_End:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
.data
Heap_Base:
	.word 0
Heap_CurrentSize:
	.word 1	
	
#Author: Sekhavat

#global procedures:
.globl huff3_init
.globl huff3_merge
.globl huff3_encode

#global .data labels:
.globl huff3_arr_lft #array with size 4*2*n bytes
.globl huff3_arr_rgt #array with size 4*2*n bytes
.globl huff3_arr_par #array with size 4*2*n bytes
.globl huff3_n

.data
	huff3_arr_lft: .space 4 #stores address of left children array
	huff3_arr_rgt: .space 4 #stores address of right children array
	huff3_arr_par: .space 4 #stores address of parent array
	huff3_n:	   .space 4 #stores number of leaves of tree
	n:		.space 4 #stores number of vertices of tree

	tmp: .word 1, 0, 2, 3
.text
#local testing
tests:
	li $a0, 4
	jal huff3_init
	li $a0, 1
	li $a1, 3
	jal huff3_merge
	li $a0, 2
	li $a1, 4
	jal huff3_merge
	li $a0, 5
	li $a1, 0
	jal huff3_merge
	li $a0, 4
	la $a1, tmp
	jal huff3_encode
	move $s0, $v0
	move $s1, $v1
	#exit
	li $v0, 10
	syscall


# inits n nodes 
# inputs: n (in $a0)
huff3_init:
	#stack:
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $ra, 4($sp)

	move $s0, $a0
	sw $s0, huff3_n
	sw $s0, n
	
	#allocating memory
	li $v0, 9
	sll $a0, $s0, 3 #4*2n
	syscall
	sw $v0, huff3_arr_lft
	
	li $v0, 9
	sll $a0, $s0, 3 #4*2n
	syscall
	sw $v0, huff3_arr_rgt
	
	li $v0, 9
	sll $a0, $s0, 3 #4*2n
	syscall
	sw $v0, huff3_arr_par
	
	#filling arrays with -1 (null)
	lw $t0, huff3_arr_lft
	lw $t1, huff3_arr_rgt
	lw $t2, huff3_arr_par
	sll $t3, $s0, 3
	add $t3, $t3, $t0
	li $t4, -1
    init_L1:
	sw $t4, 0($t0)
	sw $t4, 0($t1)
	sw $t4, 0($t2)
	addi $t0, $t0, 4
	addi $t1, $t1, 4
	addi $t2, $t2, 4
	bne $t0, $t3, init_L1

	lw $s0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra


# merges subtrees with roots left and right and returns number of new root
# inputs: 	index of left child (in $a0)
#		index of right child (in $a1)
# output:	index of new node added to tree (in $v0)
huff3_merge:
	lw $t0, n
	sll $t1, $t0, 2 #t1=par*4
	sll $t2, $a0, 2 #t2=left*4
	sll $t3, $a1, 2 #t3=right*4
	
	#updating parents of left and right
	lw $t4, huff3_arr_par
	add $t5, $t4, $t2
	sw $t0, 0($t5)
	add $t5, $t4, $t3
	sw $t0, 0($t5)
	
	#updating left and right of parent
	lw $t4, huff3_arr_lft
	lw $t5, huff3_arr_rgt
	add $t4, $t4, $t1
	add $t5, $t5, $t1
	sw $a0, 0($t4)
	sw $a1, 0($t5)
	
	#return value
	move $v0, $t0
	
	#updating n
	addi $t0, $t0, 1
	sw $t0, n
	
	jr $ra
    	

#gets address of a symbol (a word between 1 and n) and returns its encoded bits
#inputs: 	count of symbols of array (in $a0)
#		begin address of symbols array (in $a1)
# outputs: 	begin address of encoded bits in reverse order (in $v0)
#		count of bits of encoded text (in $v1)
huff3_encode:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)

	sll $a0, $a0, 2
	move $t0, $a1	#t0 = iterator of symbols to be encoded
	add $t1, $a0, $t0 #t1 = last iterator
	
	#swaping $t0, $t1 with $t1-4, $t0-4:
	addi $t2, $t0, -4
	addi $t0, $t1, -4
	move $t1, $t2
	
	#allocate memory for ans array NOTE: a0 is already set
	li $v0, 9
	syscall	   	# now v0 is begin of ans array
	li $v1, 0  	# v1 is count of bits of ans array
	move $t2, $v0	# t2 is pointer to currently writing byte
	li $t3, 1	# t3 is mask of currntly writing bit
	li $t7, 0	# t7 is value of currently writing byte
	
	lw $s0, huff3_arr_par #s0=&par[0]
	lw $s1, huff3_arr_lft #s1=&lft[1]

    encode_L1:
	lw $t4, 0($t0) #t4 = v
    encode_L2:
	sll $t5, $t4, 2
	add $t5, $t5, $s0
	lw $t5, 0($t5) #t5 = par(v)
	beq $t5, -1, next_symbol
	sll $t6, $t5, 2
	add $t6, $t6, $s1
	lw $t6, 0($t6) 		#t6 = left(par(v))
	beq $t6, $t4, dont_add_mask
	add $t7, $t7, $t3
    dont_add_mask:
    	sll $t3, $t3, 1
    	addi $v1, $v1, 1
    	bne $t3, 256, dont_go_next_byte
    	sb $t7, 0($t2)	#writing flag to memory
    	addi $t2, $t2, 1
    	li $t7, 0
    	li $t3, 1
    dont_go_next_byte:   	
	move $t4, $t5
	j encode_L2
	
    next_symbol:
    	addi $t0, $t0, -4
    	bne $t0, $t1, encode_L1
        
        #writing remaining byte
        beq $t3, 1, dont_write_remain
	sb $t7, 0($t2)
    dont_write_remain:
    
    	
    encode_end:	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra

	
.globl main

.text
main:
	jal encoder
	li $v0, 10
	syscall

#first write the Huffman tree in the output
#then write the encrypted text in the output

.text
.globl huff_print_tree
huff_print_tree:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s1, 4($sp) #s1:n
	sw $s2, 8($sp) #s2: address of input
	sw $s3, 12($sp)#s3: number of charachter in input
	sw $s4, 16($sp)#s4: address of output array

	move $s2, $a0 #a0 is the address of array_input
	move $s3, $a1

	lw $s1, huff3_n

	li $v0, 1
	move $a0, $s1
	syscall #print n: number of leaves in Huffman tree

	li $v0, 4
	la $a0, endl
	syscall #print \n

	move $a0, $s1
	lw $a1, inp_symb_ptr
	jal print_array

	sll $s1, $s1, 1 #2*n
	addi $s1, $s1, -1 #2*n-1

	move $a0, $s1
	lw $a1, huff3_arr_lft
	jal print_array

	move $a0, $s1
	lw $a1, huff3_arr_rgt
	jal print_array

	#allocate memory
	li $v0, 9
	sll $a0, $s3, 2
	syscall
	move $s4, $v0

	#from here s1 is temp
	li $s1, 0

	huff_tree_print_loop: 
		sll $t1, $s1, 2
		add $t2, $t1, $s2
		lw $a0, 0($t2)
		jal bsearch
		sll $t1, $s1, 2
		add $t2, $t1, $s4
		sw $v0, 0($t2)
		addi $s1, $s1, 1
	bne $s1, $s3, huff_tree_print_loop

	move $a0, $s3 
	move $a1, $s4
	jal huff3_encode

	#from here s2 is begin address of array
	move $s2, $v0
	#from here $s3 is nuber of bits
	move $s3, $v1

	li $v0, 1
	move $a0, $s3
	syscall #print number of bits

	li $v0, 4
	la $a0, endl
	syscall #print \n

	output_loop:
		li $v0, 11
		lb $a0, 0($s2)
		syscall #print number of bits
		addi $s2, $s2, 1
		addi $s3, $s3, -8
	blt $zero, $s3, output_loop

	li $v0, 4
	la $a0, endl
	syscall #print \n

	lw $ra, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	addi $sp, $sp, 20

	jr $ra

print_array:
	move $t0, $a0 #size of the array
	move $t1, $a1 #address of the array

	li $t3, 0	
	huff_print_array_loop:
		beq $t3, $t0, huff_print_aray_exit
		sll $t4, $t3, 2
		add $t4, $t4, $t1
		li $v0, 1
		lw $a0, 0($t4) # load the t3 elementof array to the a0
		syscall

		li $v0, 4
		la $a0, endl
		syscall
		
		addi $t3, $t3, 1
	b huff_print_array_loop
	huff_print_aray_exit:
	jr $ra

.data
endl: .asciiz "\n"
space: .asciiz " "
.align 4

.globl sort

.text
sort:
	# $a0: number of elemnts
	# $a1: pointer to array containing keys
	# $a2: pointer to array containing values
	
	addi $sp, $sp, -20
	sw $ra,  0($sp)
	sw $s0,  4($sp)
	sw $s1,  8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	sll $s0, $a0, 2
	add $s1, $a1, $zero
	add $s2, $a2, $zero
	
	jal heap_init
	
	li $s3, 0
	insert:
		add $t0, $s1, $s3
		add $t1, $s2, $s3
		lw $a0, ($t0)
		lw $a1, ($t1)
		jal heap_insert
		addi $s3, $s3, 4
		blt $s3, $s0, insert
	
	li $s3, 0
	remove:
		jal heap_extract_min
		add $t0, $s1, $s3
		add $t1, $s2, $s3
		sw $v0, ($t0)
		sw $v1, ($t1)
		addi $s3, $s3, 4
		blt $s3, $s0, remove
	
	lw $ra,  0($sp)
	lw $s0,  4($sp)
	lw $s1,  8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20
	jr $ra

