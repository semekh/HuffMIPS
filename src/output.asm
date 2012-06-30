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
#lw $a1, huff3_arr_valu_sort #TODO: in bayad emse arayei bashe ke simbolo sort shode toshand! esmesh yadam nsit!
#jal print_array

li $v0, 4
la $a0, endl
syscall #print \n

sll $s1, $s1, 1 #2*n
addi $s1, $s1, -1 #2*n-1

move $a0, $s1
lw $a1, huff3_arr_lft
#jal print_array

li $v0, 4
la $a0, endl
syscall #print \n

move $a0, $s1
lw $a1, huff3_arr_rgt
#jal print_array

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
#jal binary_search #TODO esmesh alekiest!
sll $t1, $s1, 2
add $t2, $t1, $s4
sw $v0, 0($t2)
addi $s1, $s1, 1
bne $s1, $s3, huff_tree_print_loop

move $a0, $s3 
move $a1, $s4
#jal huff3_encode

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

.data
endl: .asciiz "\n"

