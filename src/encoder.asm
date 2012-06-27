.globl encoder
.globl enc_inp_ptr

.text
encoder:
	# impl:
	# read_input()
	# n = v0
	# encoder_input_ptr = v1
	# freq(n, encoder_input_ptr)
	
	jr $ra

read_input:

.data
enc_inp_ptr:
	.space 4
