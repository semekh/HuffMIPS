# first write the Huffman tree in the output
# then write the encrypted text in the output

.text

addi $sp, $sp, -8
sw $ra, 0($sp)
sw $s1, 4($sp)

#lw $s1, 0(n)

li $v0, 1
move $a0, $s1
syscall #print n

li $v0, 4
#la $a0, 0(endl)
syscall #print \n

sll $s1, $s1, 1 #2*n
addi $s1, $s1, -1 #2*n-1

move $a0, $s1
#lw $a1, 0(huff3_arr_par)
jal print_array

li $v0, 4
#la $a0, 0(endl)
syscall #print \n

move $a0, $s1
#lw $a1, 0(huff3_arr_lft)
jal print_array

li $v0, 4
#la $a0, 0(endl)
syscall #print \n

move $a0, $s1
#lw $a1, 0(huff3_arr_rgt)
jal print_array

lw $ra, 0($sp)
lw $s1, 4($sp)
addi $sp, $sp, 8

jr $ra

.data
endl: .asciiz "\n"

# TODO implementin the function which print encrypted code and the print_array




