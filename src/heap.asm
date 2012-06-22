# Author: Aghamir
.globl heap_init
.globl heap_insert
.globl heap_extract_min

.text
heap_init:
	# initialize a min_heap of capacity n
	# $a0: n
	
	# impl:
	# allocate two arrays of size n
	# store their pointer in key_arr_ptr and val_arr_ptr
	jr $ra

heap_insert:
	# $a0: key
	# $a1: value
	jr $ra

heap_extract_min:
	# $v0: min_el.key
	# $v1: min_el.value
	jr $ra

.data
key_arr_ptr:
	.space 4
val_arr_ptr:
	.space 4
