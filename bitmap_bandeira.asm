
.data
.include "bandeira.s"

.text
	li t1,0xFF000000	# endereco inicial da Memoria VGA
	li t2,0xFF012C00	# endereco final 
	la s1,bandeira		# endereeço da bandeira que está no arquivo  bandeira.s
	addi s1,s1,8		# primeiros pixels depois das informaoes de numero linha e coluna
LOOP: 	beq t1,t2, EXIT		# Se for o ultimo endereço sai do loop
	lw t3,0(s1)		# le uma word
	sw t3,0(t1)		# escreve a word na memoria VGA
	addi t1,t1,4		# soma 4 ao endereço
	addi s1,s1,4
	j LOOP			# volta a verificar

EXIT:				# volta a verificar
li a7,10			# ecall de exit
ecall
