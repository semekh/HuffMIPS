.text
.globl heap_init
.globl heap_insert
.globl heap_extract_min

heap_init:
	li $v0, 9
	sll $a0, $a0, 3
	syscall
	sw $v0, Heap_Base
	li $v0, 1
   	sw $v0, Heap_CurrentSize
	jr $ra

heap_insert:
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $ra, 4($sp)
	lw $s0, Heap_Base
	lw $t0, Heap_CurrentSize
	sll $t1, $t0, 3
	add $t1, $t1, $s0
	sw $a0, 0($t1)
	sw $a1, 4($t1)
	addi $t0, $t0, 1
	sw $t0, Heap_CurrentSize
	addi $a0, $t0, -1
	jal Heap_InsertUpdate
	lw $ra, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
	

heap_extract_min:
	addi $sp, $sp, -16
	sw $s0, 0($sp)
	lw $s0, Heap_Base
	lw $t0, Heap_CurrentSize
	addi $t0, $t0, -1
	lw $v0, 8($s0)
	lw $v1, 12($s0)
	sll $t1, $t0, 3
	add $t1, $t1, $s0
	lw $t2, 0($t1)
	sw $t2, 8($s0)
	lw $t2, 4($t1)
	sw $t2, 12($s0)
	sw $t0, Heap_CurrentSize
	sw $ra, 4($sp)
	sw $v0, 8($sp)
	sw $v1, 12($sp)
	li $a0, 1
	jal Heap_Update
	lw $v1, 12($sp)
	lw $v0, 8($sp)
	lw $ra, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	jr $ra

Heap_Parrent:
	srl $v0, $a0, 1
	jr $ra
	
Heap_LeftChild:
	sll $v0, $a0, 1
	jr $ra
	
Heap_RightChild:
	sll $v0, $a0, 1
	add $v0, $v0, 1
	jr $ra

Heap_InsertUpdate:
	sll $t0, $a0, 3
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	ble $t0, 8, Heap_IUD_End
	Heap_IUD_Loop:
		add $t1, $s0, $t0
		srl $a0, $t0, 3		
		jal Heap_Parrent
		sll $v0, $v0, 3
		add $t2, $s0, $v0
		lw $t3, 0($t1)
		lw $t4, 0($t2)
		ble $t4, $t3, Heap_IUD_End
		sw $t4, 0($t1)
		sw $t3, 0($t2)
		lw $t3, 4($t1)
		lw $t4, 4($t2)
		sw $t4, 4($t1)
		sw $t3, 4($t2)
		add $t0, $v0, $0
		bgt $t0, 8, Heap_IUD_Loop
	Heap_IUD_End:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
Heap_Update:
	add $v1, $a0, $0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal Heap_LeftChild
	add $t1, $v0, $0
	jal Heap_RightChild
	add $t2, $v0, $0
	ble $t0, $t1, Heap_UD_secondIf
	sll $t3, $a0, 3
	sll $t4, $t1, 3
	add $t3, $s0, $t3
	add $t4, $s0, $t4
	lw $t3, 0($t3)
	lw $t4, 0($t4)
	Heap_UD_firstIf:
		ble $t3, $t4, Heap_UD_secondIf
		add $v1, $t1, $0
	Heap_UD_secondIf:
		ble $t0, $t2, Heap_UD_thirdIf
		sll $t3, $v1, 3
		sll $t4, $t2, 3
		add $t3, $s0, $t3
		add $t4, $s0, $t4
		lw $t3, 0($t3)
		lw $t4, 0($t4)
		ble $t3, $t4, Heap_UD_thirdIf
		add $v1, $t2, $0
	Heap_UD_thirdIf:
		beq $v1, $a0, Heap_UD_End
		sll $t1, $a0, 3
		add $t1, $s0, $t1
		sll $t2, $v1, 3
		add $t2, $s0, $t2
		lw $t3, 0($t1)
		lw $t4, 0($t2)
		sw $t4, 0($t1)
		sw $t3, 0($t2)
		lw $t3, 4($t1)
		lw $t4, 4($t2)
		sw $t4, 4($t1)
		sw $t3, 4($t2)
		add $a0, $v1, $0
		jal Heap_Update
	Heap_UD_End:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
.data
Heap_Base:
	.word 0
Heap_CurrentSize:
	.word 1	
	
