.globl bsearch

bsearch:
	li $t0, 0
	lw $t1, inp_symb_cnt
	lw $t8, inp_symb_ptr
	
	bs_loop:
		add $t2, $t0, $t1
		srl $t2, $t2, 1
		beq $t0 $t2, bs_not_found
		
		sll $t9, $t2, 2
		add $t9, $t9, $t8
		lw $t9, 0($t9)
		
		beq $t9, $a0, bs_found
		blt $t9, $a0, bs_right

		bs_left:
		move $t1, $t2		
		b bs_loop

		bs_right:
		move $t0, $t2
		b bs_loop		

	bs_not_found:
	li $t2, -1
	bs_found:
	move $v0, $t2	
	jr $ra

