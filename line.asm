.text

# a0 = x0
# a1 = y0
# a2 = x1
# a3 = y1
# a4 = cor
# t0 = abs(x1 - x0)
# t1 = abs(y1 - y0)
# t2 = x0 < x1 ? 1 : -1
# t3 = y0 < y1 ? 1 : -1
# t4 = (abs(x1 - x0) > abs(y1 - y0) ? abs(x1 - x0) : - abs(y1 - y0))/2

Line:
	addi sp sp -4
	sw ra (sp)

	sub t0 a2 a0  			# subtrai x1 - x0
	ABS(t0)							# pega o valor absoluto dessa subtração
	sub t1 a3 a1 	 			# subtrai y1 - y0
	ABS(t1)       			# pega o valor absoluto dessa subtração

	bgt a2 a0 maiorX		# x0 < x1 ?
	addi t2 zero -1			# se não for t2 recebe 1
	j continua					# salta pela condição verdadeira
maiorX:
	addi t2 zero 1			# se x0 < x1  t2 recebe -1
continua:
	bgt a3 a1 maiorY    # y0 < y1
	addi t3 zero -1      # se não for t3 recebe 1
	j continua2					# salta pela condição verdaeira
maiorY:
	addi t3 zero 1     # se y0 < y1  t2 recebe -1
continua2:
	bgt t0 t1  atribui  # abs(x1 - x0) > abs(y1 - y0) ?
	sub t4 zero t1			# - abs(y1 - y0) para deixar negativo
	srai t4 t4 1 				# divide - abs(y1 - y0) por 2
	j continua3
atribui:
	srai t4 t0 1        # divide abs(x1 - x0) por 2
continua3:

loop1:
	jal pixel
	bne a0 a2 calcula
	bne a1 a3 calcula
	j exit
calcula:
	mv t5 t4
	sub t6 zero t0
	ble t5 t6 proximo
	sub t4 t4 t1
	add a0 a0 t2
proximo:
	bge t5 t1  loop1
	add t4 t4 t0
	add a1 a1 t3
	j loop1

exit:
	lw ra 0(sp)
	addi sp sp 4
  ret


pixel:
  li s1 320
  mul s1 a1 s1
  add s1 s1 a0
  li s2 0xFF000000
  add s1 s1 s2
  sb a4 (s1)
  ret
