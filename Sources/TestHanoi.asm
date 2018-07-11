#HANOI TOWERS
#
#Made by Anton Delgadillo, Luis Alberto and Macias Castillon, Alondra Itzel
#
#ToDo:
#1. Optimize and go for the record!
.data

.text
	addi $a0, $0, 8 # n
	addi $a1, $0, 0x64 # Source Tower, src
	addi $a2, $0, 0x78 # Auxiliar Tower, aux
	addi $a3, $0, 0x8c # Destination Tower, des
	add $t0, $a0, $0 # Store n in temp for loop
LOOP:
	sw $t0, 0($a1) # Store top disk
	addi $t0, $t0, -1 # Decrease n by 1
	addi $a1, $a1, 1 # Increase src
	bne $t0, $0, LOOP # n must be 0
	# Hanoi(disk, src, aux, des)
	jal HANOI
	j EXIT
HANOI:
	# If (n==1)
	bne $a0, 1, ELSE
	lw $t0, -1($a1) # Retrieve top disk from src
	sw $0, -1($a1) # Delete it to complete Pop from src
	sw $t0, 0($a3) # Save it on des
	addi $a3, $a3, 1 # Increse des
	addi $a1, $a1, -1 # Decrease src
	jr $ra
ELSE:
	# Recursive Stack Init
	addi $sp, $sp, 2 # Prepare Stack
	sw $ra, -1($sp) # Push $ra
	sw $a0, 0($sp) # Push n
	# Hanoi(disk-1, src, des, aux)
	addi $a0, $a0, -1 # n--
	# Swap aux and des
	add $t0, $a2, $0
	add $a2, $a3, $0
	add $a3, $t0, $0

	jal HANOI

	# Swap aux and des
	add $t0, $a2, $0
	add $a2, $a3, $0
	add $a3, $t0, $0
	# Move disk
	lw $t0, -1($a1) # Retrieve top disk from src
	sw $0, -1($a1) # Delete it to complete Pop from src
	sw $t0, 0($a3) # Save it on des
	addi $a3, $a3, 1 # Increse des
	addi $a1, $a1, -1 # Decrease src
	# Swap src and aux
	add $t0, $a2, $zero
	add $a2, $a1, $zero
	add $a1, $t0, $zero

	jal HANOI

	# Swap src and aux
	add $t0, $a2, $zero
	add $a2, $a1, $zero
	add $a1, $t0, $zero
	# Recursive Stack Recover
	lw $ra, -1($sp) # Pop $ra
	lw $a0, 0($sp) # Pop n
	addi $sp, $sp, -2 # Release Stack

	jr $ra
EXIT:
