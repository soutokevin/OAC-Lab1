										# fn (u32, u32, u32, u32, u8)
										# a0 = x0
										# a1 = y0
										# a2 = x1
										# a3 = y1
										# a4 = cor
					          # t2 = abs(x1 - x0)
					          # t3 = abs(y1 - y0)
					          # t4 = x0 < x1 ? 1 : -1
					          # t5 = y0 < y1 ? 1 : -1
					          # t6 = (t2 > t3 ? t2 : -t3) / 2
line:               sub t2 a2 a0  			          # subtrai x1 - x0
					          ABS(t2)							          # pega o valor absoluto dessa subtração
					          sub t3 a3 a1 	 			          # subtrai y1 - y0
					          ABS(t3)       			          # pega o valor absoluto dessa subtração

					          # t4 = a0 < a2 ? 1 : -1
					          slt t4 a0 a2
					          slli t4 t4 1
					          addi t4 t4 -1

					          # t5 = a1 < a2 ? 1 : -1
					          slt t5 a1 a3
					          slli t5 t5 1
					          addi t5 t5 -1

					          bgt t2 t3  atribui            # abs(x1 - x0) > abs(y1 - y0) ?
					          sub t6 zero t3			          # - abs(y1 - y0) para deixar negativo
					          srai t6 t6 1 				          # divide - abs(y1 - y0) por 2
					          j loop1

atribui:            srai t6 t2 1                  # divide abs(x1 - x0) por 2

loop1:              li t0 0xFF000000
										li t1 320
										mul t1 a1 t1
					          add t1 t1 a0
					          add t1 t1 t0
					          sb a4 (t1)

					          bne a0 a2 calcula
					          bne a1 a3 calcula
					          ret

calcula:            mv t1 t6
					          sub t0 zero t2
					          ble t1 t0 proximo
					          sub t6 t6 t3
					          add a0 a0 t4

proximo:            bge t1 t3 loop1
					          add t6 t6 t2
					          add a1 a1 t5
					          j loop1

