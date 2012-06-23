#Author: Sekhavat

.globl huff3_init
.globl huff3_merge
.globl huff3_encode
.globl huff3_decode

.data
	huff3_array: .space 4 #stores address of array

.text

# inits n nodes
huff3_init:
	move $s0, $a0
	
	#allocating memory
	li $v0, 9
	sll $a0, $s0, 3 #4*2n
	syscall
	sw $v0, huff3_array
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
	