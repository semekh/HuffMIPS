.text
.globl heap_init
.globl heap_insert
.globl heap_extract_min

heap_init:
	li $v0, 9
	sll $a0, $a0, 2
	syscall
	sw $v0, BaseKey
	li $v0, 9
	syscall
	sw $v0, BaseValue	
	jr $ra


heap_insert:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	lw $s0, BaseKey
	lw $s1, BaseValue
	lw $t0, CurrentSize
	sll $t1, $t0, 2
	add $t1, $t1, $s0
	sw $a0, 0($t1)
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	sw $a1, 0($t1)
	addi $t0, $t0, 1
	sw $t0, CurrentSize
	sw $ra, 8($sp)
	addi $a0, $t0, -1
	jal InsertUpdate
	lw $ra, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 12
	jr $ra
	
	
heap_extract_min:
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	lw $s0, BaseKey
	lw $s1, BaseValue
	lw $t0, CurrentSize
	addi $t0, $t0, -1
	lw $v0, 4($s0)
	lw $v1, 4($s1)
	sll $t1, $t0, 2
	add $t1, $t1, $s0
	lw $t1, 0($t1)
	sw $t1, 4($s0)
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	lw $t1, 0($t1)
	sw $t1, 4($s1)
	sw $t0, CurrentSize
	sw $ra, 8($sp)
	sw $v0, 12($sp)
	sw $v1, 16($sp)
	li $a0, 1
	jal Update
	lw $v1, 16($sp)
	lw $v0, 12($sp)
	lw $ra, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 20
	jr $ra

Parrent:
	srl $v0, $a0, 1
	jr $ra
	
LeftChild:
	sll $v0, $a0, 1
	jr $ra
	
RightChild:
	sll $v0, $a0, 1
	add $v0, $v0, 1
	jr $ra

InsertUpdate:
	add $t0, $a0, $0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	blt $t0, 2, IUD_End
	IUD_Loop:
		sll $t1, $t0, 2
		add $t1, $s0, $t1
		add $a0, $t0, $0
		jal Parrent
		sll $v0, $v0, 2
		add $t2, $s0, $v0
		lw $t3, 0($t1)
		lw $t4, 0($t2)
		ble $t4, $t3, IUD_End
		sw $t4, 0($t1)
		sw $t3, 0($t2)
		sll $t1, $t0, 2
		add $t1, $s1, $t1
		add $t2, $s1, $v0
		lw $t3, 0($t1)
		lw $t4, 0($t2)
		sw $t4, 0($t1)
		sw $t3, 0($t2)
		srl $v0, $v0, 2
		add $t0, $v0, $0
		bgt $t0, 1, IUD_Loop
	IUD_End:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
Update:
	add $v1, $a0, $0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal LeftChild
	add $t1, $v0, $0
	jal RightChild
	add $t2, $v0, $0
	ble $t0, $t1, UD_secondIf
	sll $t3, $a0, 2
	sll $t4, $t1, 2
	add $t3, $s0, $t3
	add $t4, $s0, $t4
	lw $t3, 0($t3)
	lw $t4, 0($t4)
	UD_firstIf:
		ble $t3, $t4, UD_secondIf
		add $v1, $t1, $0
	UD_secondIf:
		ble $t0, $t2, UD_thirdIf
		sll $t3, $v1, 2
		sll $t4, $t2, 2
		add $t3, $s0, $t3
		add $t4, $s0, $t4
		lw $t3, 0($t3)
		lw $t4, 0($t4)
		ble $t3, $t4, UD_thirdIf
		add $v1, $t2, $0
	UD_thirdIf:
		beq $v1, $a0, UD_End
		sll $t1, $a0, 2
		add $t1, $s0, $t1
		sll $t2, $v1, 2
		add $t2, $s0, $t2
		lw $t3, 0($t1)
		lw $t4, 0($t2)
		sw $t4, 0($t1)
		sw $t3, 0($t2)
		sll $t1, $a0, 2
		add $t1, $s1, $t1
		sll $t2, $v1, 2
		add $t2, $s1, $t2
		lw $t3, 0($t1)
		lw $t4, 0($t2)
		sw $t4, 0($t2)
		sw $t3, 0($t1)
		add $a0, $v1, $0
		jal Update
	UD_End:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
.data
BaseKey:
	.word 0
BaseValue:
	.word 0
CurrentSize:
	.word 1	
	
