# Auhtor: Kasnavi
#globl procedures
.globl freq

#globl .data lables
.globl huff3_freg      #stores 4*2*n bytes - frequencies of input numbers

.data
	huff3_freg: .space 4 
.text

freq:
	# Given an array of N words, find the frequency of each word
	# $a0: number of words in the array (N)
	# $a1: address of an array of words
	# $v0: address of an array, $v0[i] = frequency($a1[i])

	# $t0: end of a1 array, $t1: first pointer, $t2: second pointer, $t3: hold repeated numbers
	# $t4: hold current value, $t5: hold next value, $t6: save place pointer

	la $a1, L1
	addi $a0, $0, 4
	addi $a2, $0, 3
	sw $a2, 0($a1)
	addi $a2, $0, 4
	sw $a2, 4($a1)
	addi $a2, $0, 4
	sw $a2, 8($a1)
	addi $a2, $0, 5
	sw $a2, 12($a1)
	

	move $t0, $a0
	sll $t0, $t0, 2
	add $t0, $t0, $a1
	move $t1, $a1
	move $t2, $a1
	la $v0, huff3_freg
	move $t6, $v0

Find_Frequency_number:
	li $t3, 0 
	beq $t1, $t0, Exit
	lw $t4, 0($t1)
Inc_Number:
	addi $t3, $t3, 1
	addi $t1, $t1, 4
	beq $t1, $t0, Fix_Frequency
	lw $t5, 0($t1)
	beq $t4, $t5, Inc_Number
Fix_Frequency:
	sw $t3, 0($t6)
	addi $t2, $t2, 4
	addi $t6, $t6, 4
	bne $t1, $t2, Fix_Frequency

	bne $t2, $t0, Find_Frequency_number

Exit:
	jr $ra
