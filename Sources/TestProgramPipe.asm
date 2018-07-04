.text
	addi $t0, $zero, 5
	add $t1, $t0, $zero
	addi $zero, $zero, $zero
	addi $t1, $t1, 2
	addi $t2, $t2, 3
	addi $t3, $t3, 0x1001
	sw $t2, 0($t3)
	
	add $s0, $t2, $t1
	sub $s1, $s0, $t3
	addi $zero, $zero, $zero
	lw $t2, 0($t3)
	addi $s2, $s2, $t4
	addi $zero, $zero, $zero
	or $s2, $s2, $t4
	sll $s7, $s2, 2