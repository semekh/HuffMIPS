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
	li $a0, 3
	li $a1, 5
	jal huff3_merge
	li $a0, 10
	li $a1, 2
	jal huff3_merge
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
	lw $t0, n
	sll $t1, $t0, 2 #t1=par*4
	sll $t2, $a0, 2 #t2=left*4
	sll $t3, $a1, 2 #t3=right*4
	
	#updating parents of left and right
	lw $t4, arr_par
	add $t5, $t4, $t2
	sw $t0, 0($t5)
	add $t5, $t4, $t3
	sw $t0, 0($t5)
	
	#updating left and right of parent
	lw $t4, arr_lft
	lw $t5, arr_rgt
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
huff3_encode:
	jr $ra

#gets address of starting bit of an encoded symbol and returns its number	
huff3_decode:
	jr $ra
	
