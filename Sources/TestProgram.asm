
	.text
	# Test
	#lui  $1, 152
	#ori  $sp, $1, 48532
	addi $t0, $0, 5		 #t0 = 5
	add  $s0, $0, $t0  #s0 = 5
	jal  GO
	#beq  $s0, $t0, GO  #Jump to GO
	addi $t0, $0, 2		 #t0 = 2
	sub  $s0, $s0, $t0 #s0 = 3
	andi $t0, $t0, 3	 #t0 = 2
	ori  $t0, $t0, 1	 #t0 = 3
	or	 $t1, $s0, $t0 #t1 = 3
	and  $t2, $t1, $t0 #t2 = 3
	nor  $t2, $t2, $t1 #t2 = 0
	addi $t1, $t1, 1	 #t1 = 4
	sll  $t1, $t1, 1   #t1 = 8
	srl  $t1, $t1, 1   #t1 = 4
	j EXIT
	j NEXT
	GO:
	addi $t1, $0, 16	 #t1 = 16
	NEXT:
	addi $t1, $0, 12   #t1 = 12
	sw   $t1, 4($sp)
	lw   $t2, 4($sp)
	jr   $ra
	EXIT:
