# Nombres: 
#	Carmen Martínez is703358
#	Maritza Mendoza is702016
# Fecha: 
#	24/02/18



.text

main:
		nop
		ori	$s0, 3		#$s0 representa N disks
		lui	$t0, 0x1001	#parte alta para tabla de direcciones de torres. 10010000 representa puntero a Torre1
		sll	$t9, $s0, 2	#Posición donde se encuentra el Tamaño de la Torre
		lui	$sp, 0x1001 	#Posicion del stack pointer
		addi	$sp, $sp, 4092	#4092 = 1023 * 4

		
		or	$t1, $t0, 32	#Sabemos que la torre1 comenzará en oX10010020
		sub	$t1, $t1, 4	#Tener el puntero de la torre 2 en un registro	
		nop
		sw	$t1, 0($t0)	#puntero t1 a direccion t0
		add	$t1, $t1, $t9	#sumar desplazamiento del puntero

		nop
		sw	$t1, 4($t0)	#puntero de t2 a direccion t0
		add	$t1, $t1, $t9	#sumar desplazamiento del puntero
		sw	$t1, 8($t0)	#puntero de t3 a direccion t0
	
		lui	$a1, 0x1001	#Almacenamos la parte alta para el puntero de posiciones finales Torre Inicial
		lui	$a2, 0x1001	
		ori	$a2, 4		#Almacenamos la parte alta para el puntero de posiciones finales Torre Destino
		lui	$a3, 0x1001
		ori	$a3, 8		#Almacenamos la parte alta para el puntero de posiciones finales Torre Auxiliar
		
		#Llenado de Torre 1
		
		or	$s1, $s0, $zero		#Auxiliar de numero de discos
		lw	$s3, 0($a1)
ciclo:		slti	$s2, $s1, 1 		# si el contador < 1, entonces $s2 tendrá un 1
		beq	$s2, 1, cargaTorres	# si t0 es un 0, indica que el contador ya no es menor a 9, por lo que hay que parar el ciclo	
		addi	$s3, $s3, 4		#Cambiamos a la siguiente posicion del "arreglo" de la torre 1
		sw	$s1, 0($s3)		#Guardamos el valor del disco en la torre
		sub	$s1, $s1, 1		#Dismuir contador del loop y el valor del disco siguiente
		j	ciclo

cargaTorres:	or	$a0, $zero, $s0		#s1 Auxiliar discos
		sw	$s3, 0($a1)		# Nuevo valor del puntero de la torre 1
		jal 	hanoi
		j 	exit

		
						
hanoi:		bne	$a0, 1, loop		# Si s1 == 1 es caso base y hacemos movimiento, de lo contrario loop
		
		lw	$t2, 0($a2)		#Cargamos valor del puntero destino
		
		lw	$t1, 0($a1)		#Cargamos valor del puntero inicial
		
		addi	$t2, $t2, 4		#Desplazar puntero de torreDestino
		lw	$s1, 0($t1)		#Obtener el valor del puntero de TorreInicial
		
		sw	$zero, 0($t1)		#Limpiar valor de Torre Inicial
		
		sw	$s1, 0($t2)		#Guardar el valor en la ultima posicion de la torreDestino
		
		sub	$t1, $t1, 4		#Recorrer puntero a la última posicion de la torre inicial
		sw	$t1, 0($a1)		#a1 tiene el valor de la direccion de memoria del ultimo disco de torre incial
		sw	$t2, 0($a2)		#a2 tiene el valor de la direccion de memoria del ultimo disco de torre destino
		jr	$ra
		
loop:		addi 	$sp, $sp,-20		# Decrementa el stack pointer 16 guardar 5 variables
		sw 	$ra 16($sp) 		# Guarda el resultado en ra
		sw	$a0, 12($sp)		# Guarda numero de discos
		sw	$a1, 8($sp)		#Guardamos Torre Inicial
		sw	$a2, 4($sp)		#Guardamos Torre Auxiliar
		sw	$a3, 0($sp)		#Guardamos Torre Destino
		add	$t4, $a3, $zero		
		add	$a3, $a2, $zero	
		add	$a2, $t4, $zero
		sub	$a0, $a0, 1		#Discos = Discos - 1
		jal	hanoi
moviemiento2:	lw	$a0, 12($sp)		#Obtenemos Discos
		lw	$a1, 8($sp)		#Obtenemos Torre Inicial
		lw	$a2, 4($sp)		#Obtenemos Torre Destino
		lw	$a3, 0($sp)		#Obtenemos Torre Auxiliar
		lw	$t2, 0($a2)		#Cargamos valor del puntero destino
		
		lw	$t1, 0($a1)		#Cargamos valor del puntero inicial


		addi	$t2, $t2, 4		#Desplazar puntero de torreDestino
		lw	$s1, 0($t1)		#Obtener el valor del puntero de TorreInicial

		
		
		sw	$s1, 0($t2)		#1Guardar el valor en la ultima posicion de la torreDestino
		
		sw	$zero, 0($t1)		#Limpiar valor de Torre Inicial
		sub	$t1, $t1, 4		#Recorrer puntero a la última posicion de la torre inicial
		lw	$ra, 16($sp)		#Obtener ra
		sw	$t1, 0($a1)		#a1 tiene el valor de la direccion de memoria del ultimo disco de torre incial
		sw	$t2, 0($a2)		#a2 tiene el valor de la direccion de memoria del ultimo disco de torre destino

segundaLlamada:	sub	$a0, $a0, 1		#Dismiuimos discos
		add	$t4, $a3, $zero		
		add	$a3, $a1, $zero		#swap de variables
		add	$a1, $t4, $zero
		jal	hanoi
		lw	$ra, 16($sp)		#Tomamos el nuevo ra
		add 	$sp, $sp, 20
		jr	$ra	
		nop		
exit:
	
