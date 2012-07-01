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
.text

.data
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

	
