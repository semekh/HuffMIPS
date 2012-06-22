.globl sort

.text
sort:
	# $a0: number of elemnts
	# $a1: pointer to array containing keys
	# $a2: pointer to array containing values
	
	# impl:
	# heap_init(a0)
	# for i = 0 to a0
	# 	heap_insert(a1[i], a2[i])
	# for i = 0 to a0
	# 	heap_extract_min()
	# 	a1[i] = v0
	# 	a2[i] = v1
	jr $ra