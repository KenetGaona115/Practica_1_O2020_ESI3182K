#Torres de Hanoi Recursivo
#Autores: Maria Luisa Ortiz Carstensen, Aldrin Kenet Gaona Montes
#Exp: ie717781, is709029
.data
.text

#Guardamos el numero de discos
addi $s0, $zero, 3
#Guardamos la parte alta de la direccion inicial
addi $s1, $zero, 0x1001
#Hacemos un shift left para recorrer 16 bits de la parte baja
#Direccion del primer palo
sll $s1, $s1, 16
#Direccion del palo del medio (aux) 
addi $s2, $s1, 0x0020
#Direccion del palo final
addi $s3, $s1, 0x0040

#Inicializamos $t0 en 0 para ser el contador del ciclo
add $t0, $zero, $zero
#Llenamos el primer palo con los discos que estan en $s1
#1 >> disco mas grande
#2 >> disco mediano
#3 >> disco chico...

fill_start_rod:
#Si no hay mas discos que poner, brincamos al main
beq $t0, $s0, main
#Incrementamos en 1 el contador
addi $t0, $t0, 1
#Guardamos el valor de $t0  
sw $t0, 0($s1)
#Incrementamos en 4 a $s1 para apuntar a la siguiente direccion y poder escribir
addi $s1, $s1, 4
#Volvemos a ejecutar el ciclo
j fill_start_rod

#Main
main: 
#Guardamos el numero de discos en $a0
add $a0, $zero, $s0
#Guardamos la direccion del palo inicial en $a1
add $a1, $zero, $s1
#Guardamos la direccion del palo final en $a2
add $a2, $zero, $s3
#Guardamos la direccion del palo aux en $a3
add $a3, $zero, $s2
#Establecemos a $s7 para comparar el caso base (n==1)
addi $s7, $zero, 1
#Llamamos a la funcion recursiva
jal hanoi_function
#End
j end

hanoi_function:
#Guardamos la direccion de retorno en el stack
addi $sp, $sp, -4
sw $ra, 0($sp)
#Validamos el caso base (n==1)
beq $a0, $s7, base_case
#Restamos en 1 al numero de discos
addi $a0, $a0, -1
#Guardamos en $s6 la direccoion a la que apunta $a2
#Usamos a $s6 como temp
add $s6, $zero, $a2
#Invertimos las direcciones del palo aux y el final
add $a2, $zero, $a3
add $a3, $zero, $s6
#Llamamos a la funcion recursiva
jal hanoi_function

#Guardamos en $s6 la direccoion a la que apunta $a2
add $s6, $zero, $a2
#Revertimos a la direccion original del palo aux y el final
add $a2, $zero, $a3
add $a3, $zero, $s6
#Restamos en 4 a $a1 para que apunte al dato
addi $a1, $a1, -4
#Guardamos el dato al que apunta $a1 (primer palo)
lw $v0, 0($a1)
#Ponemos un 0 para "borrar el dato" al que apunta $a1 (primer palo)
sw $zero, 0($a1)
#Guardamos el dato dentro del palo final
sw $v0, 0($a2)
#incrementamos $a2 para guardar el siguiente dato
addi $a2, $a2, 4
#Restamos en 1 al numero de discos guardado en $a0
addi $a0, $a0, -1
#Guardamos en $s6 la direccoion a la que apunta $a1
add $s6, $zero, $a1
#Invertimos las direcciones del palo aux y el inicial
add $a1, $zero, $a3
add $a3, $zero, $s6
#Volvemos a llamar a la funcion recursiva
jal hanoi_function
#Guardamos en $s6 la direccoion a la que apunta $a1
add $s6, $zero, $a1
##
#Invertimos las direcciones del palo aux y el inicial
add $a1, $zero, $a3
add $a3, $zero, $s6
#Sumamos en 1 el numero de discos
addi $a0, $a0, 1
#Obtenemos la direccion de retorno al main
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

#Caso base, cuando el numero de discos es 1
base_case:
#Restamos en 4 a $a1 para poder obtener el dato al que apunta
addi $a1, $a1, -4
#Guardamos en $v0 el dato al que $a1 apunta
lw $v0, 0($a1)
#Ponemos un 0 para "borrar el dato" al que apunta $a1 (primer palo)
sw $zero, 0($a1)
#Guardamos el dato en la direccion a la que apunta $a2
sw $v0, 0($a2)
#Incrementamos $a2 para guardar el siguiente dato
addi $a2, $a2, 4
#Sumamos 1 al numero de discos
addi $a0, $a0, 1
#Obtenemos la direccion de retorno y regresamos a la funcion recursiva
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

end:
nop
nop
nop
