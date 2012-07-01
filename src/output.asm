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
	lw $a1, inp_symb_ptr #TODO: SAJAD: CHECK KON
	jal print_array

	li $v0, 4
	la $a0, endl
	syscall #print \n

	sll $s1, $s1, 1 #2*n
	addi $s1, $s1, -1 #2*n-1

	move $a0, $s1
	lw $a1, huff3_arr_lft
	jal print_array

	li $v0, 4
	la $a0, endl
	syscall #print \n

	move $a0, $s1
	lw $a1, huff3_arr_rgt
	jal print_array

	li $v0, 4
	la $a0, endl
	syscall #print \n

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
		jal bsearch #TODO SAJAD: CHECK KON
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

.globl print_array
print_array:
move $t0, $a0 #size of the array
move $t1, $a1 #address of the array
li $t3, 0

huff_print_array_loop: beq $t3, $a0, huff_print_aray_exit

add $t4, $t3, $t1
li $v0, 1
lw $a0, 0($t4) # load the t3 elementof array to the a0
syscall

li $v0, 4
la $a0, space
syscall #print space

j huff_print_array_loop

li $v0, 4
la $a0, endl
syscall #print \n

huff_print_aray_exit:
jr $ra

.data
endl: .asciiz "\n"
space: .asciiz " "
.align 4

