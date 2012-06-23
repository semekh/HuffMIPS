#Author: Sekhavat

.globl huff3_init
.globl huff3_merge
.globl huff3_encode
.globl huff3_decode

# inits n nodes
huff3_init:
	jr $ra

# merges subtrees with roots left and right and returns number of new root
huff3_merge:
	jr $ra

#gets address of a symbol (a word between 1 and n) and returns its encoded bits
huff3_encode:
	jr $ra

#gets address of starting bit of an encoded symbol and returns its number	
juff3_decode:
	jr $ra
	