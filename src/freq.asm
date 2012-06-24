# Auhtor: Kasnavi
#globl procedures
.globl freq

#globl .data lables
.globl huff3_freg

.data
	huff3_freg: space: 4 #stores freguencies of input numbers

.text
	
freq:
	# Given an array of N words, find the frequency of each word
	# $a0: number of words in the array (N)
	# $a1: address of an array of words
	# $v0: address of an array, $v0[i] = frequency($a1[i])
	
	# $t0: end of a1 array, $t1: first pointer, $t2: second pointer, $t3: hold repeated numbers
	# $t4: hold current value, $t5: hold next value, $t6: save place pointer

	move $t0, $a0
	slli $t0, 2
	add $t0, $a1
	move $t1, $a1
	move $t2, $a1
	la $v0, huff3_freg
	move $t6, $v0

Find_Frequency_number:
	li $t3, 0
	beg $t1, $t0, Exit
	lw $t4, 0($t1)
Inc_Number:
	inc $t3
	addi $t1, $t1, 4
	beg $t1, $t0, Fix_Frequency
	lw $t5, 0($t1)
	beg $t4, $t5, Inc_number
Fix_frequency:
	sw $t3, 0($t6)
	addi $t2, $t2, 4
	addi $t6, $t6, 4
	bne $t1, $t2, Fix_freguency
	
	bne $t2, $t0, Find_Frequency_number

Exit:
	jr $ra
