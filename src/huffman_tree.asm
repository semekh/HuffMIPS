#Author: Sekhavat

.globl huff3_init
.globl huff3_merge
.globl huff3_encode
.globl huff3_decode

.data
	arr_lft: .space 4 #stores address of left children array
	arr_rgt: .space 4 #stores address of right children array
	arr_par: .space 4 #stores address of parent array
	n: .space 4 
.text

#local testing
tests:
	li $a0, 10
	jal huff3_init
	#exit
	li $v0, 10
	syscall


# inits n nodes
huff3_init:
	#stack:
	subi $sp, $sp, 8
	sw $s0, 0($sp)
	sw $ra, 4($sp)

	move $s0, $a0
	sw $s0, n
	
	#allocating memory
	li $v0, 9
	sll $a0, $s0, 3 #4*2n
	syscall
	sw $v0, arr_lft
	
	li $v0, 9
	sll $a0, $s0, 3 #4*2n
	syscall
	sw $v0, arr_rgt
	
	li $v0, 9
	sll $a0, $s0, 3 #4*2n
	syscall
	sw $v0, arr_par
	
	#filling arrays with -1 (null)
	lw $t0, arr_lft
	lw $t1, arr_rgt
	lw $t2, arr_par
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
huff3_merge:
	jr $ra

#gets address of a symbol (a word between 1 and n) and returns its encoded bits
huff3_encode:
	jr $ra

#gets address of starting bit of an encoded symbol and returns its number	
huff3_decode:
	jr $ra
	
