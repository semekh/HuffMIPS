.globl sort

.text
sort:
	# $a0: number of elemnts
	# $a1: pointer to array containing keys
	# $a2: pointer to array containing values
	
	subi $sp, $sp, 16
	sw $ra,  0($sp)
	sw $s0,  4($sp)
	sw $s1,  8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	sll $s0, $a0, 2
	add $s1, $a1, $zero
	add $s2, $a2, $zero
	
	jal heap_init
	
	li $s3, 0
	insert:
		add $t0, $s1, $s3
		add $t1, $s2, $s3
		lw $a0, ($t0)
		lw $a1, ($t1)
		jal heap_insert
		addi $s3, $s3, 4
		blt $s3, $s0, insert
	
	li $s3, 0
	remove:
		jal heap_extract_min
		add $t0, $s1, $s3
		add $t1, $s2, $s3
		sw $v0, ($t0)
		sw $v1, ($t1)
		addi $s3, $s3, 4
		blt $s3, $s0, remove
	
	lw $ra,  0($sp)
	lw $s0,  4($sp)
	lw $s1,  8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 16
	jr $ra
