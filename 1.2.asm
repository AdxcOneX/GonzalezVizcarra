#autor: Luis Fernando Rguez
#	
#fecha: 05/07/2018
#clase: Arquitectura de computadoras
#profesor: Jose Luis Pizano
.text

main:
 	addi $s0, $s0, 3
 	#numero de discos
	add $a0, $zero, $s0
	#temporal para nDiscos a manipular
	addi $s1, $s1, 0x10010000	# T1 = init
	addi $s2, $s2, 0x10010040	# T2 = aux
	addi $s3, $s3, 0x10010080	# T3 = dest
	#partimos de la direccion de memoria 1001000 para evitar errores
	#faltaba un cero para la memoria por eso no funcionaba
	j FillTowers
hanoi:
	sub $sp ,$sp, 4
	#guardamos 2 espacios de memoria (2 bytes) uno para la direccion del registo y otra para el reg de los discos
	#sw $a0, 4($a0)
	sw $ra, 0($sp)
	#
	bne $a0, 1, else
	#Encontre un problema que no funcionaba por no emplear el registro correcto para la funcion bne	
	lw $v0, ($s1)	
	#Usamos proceso read del primer disco en la primer torre	
	jal Swap
	#Funcion swap recorre la memoria un byte para utilizar el siguiente disco
	#usando el caso base en que el primer disco siempre lo enviamos a la ultima torre
	#a la torre Dest le aumentamos un espacio de mem
	j endHanoi
else:
	#hanoi (O, D, A)
	#################
	addi $a0, $a0, -1
	#restamos 1 a la temp	
	addi $v1, $s3, 0
	#guardamos la torre dest en una temp	
	addi $s3, $s2, 0
	#movemos la torre aux a torre dest	
	addi $s2, $v1, 0
	#movemos temp a torre aux para finalizar este mov	
	jal hanoi
	#llama a hanoi de nuevo para que se vuelva a ejcutar la funcion
	#asi mismo resguarde otro espacio en el stack para otro disco
	addi $v0, $s2, 0
	addi $s2, $s3, 0
	addi $s3, $v0, 0
	#swap (O, D)
	jal Swap
	#Funcion swap recorre la memoria un byte para utilizar el siguiente disco
	#usando el caso base en que el primer disco siempre lo enviamos a la ultima torre
	#a la torre Dest le aumentamos un espacio de mem
	################
	#hanoi (A, 0, D)
	###############
	#buscamos el switch de los discos de aux a init
	addi $v0, $s2, 0
	#cargamos el disco de Aux a una temp
	addi $s2, $s1, 0
	#
	addi $s1, $v0, 0
	#
	sub $a0, $a0, 1
	#
	jal hanoi
	#llamamos hanoi de nuevo para la recursividad
	addi $v0, $s1, 0
	addi $s1, $s2, 0
	addi $s2, $v0, 0
	####
endHanoi:
	lw $ra, 0($sp)
	#lw $a0, 4($sp)
	addi $sp ,$sp, 4
	addi $a0,$a0,1
	jr $ra
	
	
Swap:
	#Funcion swap recorre la memoria un byte para utilizar el siguiente disco
	#usando el caso base en que el primer disco siempre lo enviamos a la ultima torre
	#a la torre Dest le aumentamos un espacio de mem
	#################
	addi $s1, $s1, -4
	#reducir el espacio de bytes que ya empleamos para ir al siguiente nDisco
	#sll
	lw $t0, 0($s1)
	#realizamos op de lectura de la primer torre
	sw  $t0, 0($s3)
	#op de escritura en la torre dest
	sw  $zero, 0($s1)
	#limpiamos el lugar de lectura de torre init
	addi $s3, $s3, 4
	#agregamos espacio para el siguiente disco
	#srl
	jr $ra
	#regresamos al registo guardado en el stack

FillTowers:
	beq $s0,$0, hanoi
	#if nDiscos == NULL j a hanoi
	#else 		
 	sw $s0, ($s1)	
 	#guardamos el primer valor en la direccion 10010000		
	sub $s0, $s0, 1		
	#restamos 1 a nDiscos para guardar el siguiente "disco en la siguiente direccion de mem
	addi $s1, $s1, 4
	#srl $s0, $s0, 4
	#avanzamos a la siguiente posicion de memoria de la torre de inicio
	#preguntar si se puede son srl		
	j FillTowers			
	#se realiza hasta que nDiscos == null
	###########
	jal hanoi
	
End:



	
