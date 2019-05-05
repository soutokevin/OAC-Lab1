										# fn (u32, u32, u32, u32, u8)
										# a0 = x0
										# a1 = y0
										# a2 = x1
										# a3 = y1
										# a4 = cor
line:               addi sp sp -20
					          sw s1  0(sp)                  # s1 = abs(x1 - x0)
					          sw s2  4(sp)                  # s2 = abs(y1 - y0)
					          sw s3  8(sp)                  # s3 = x0 < x1 ? 1 : -1
					          sw s4 12(sp)                  # s4 = y0 < y1 ? 1 : -1
					          sw s5 16(sp)                  # s5 = (s1 > s2 ? s1 : -s2) / 2
					          li t0 0xFF000000

					          sub s1 a2 a0  			          # subtrai x1 - x0
					          ABS(s1)							          # pega o valor absoluto dessa subtração
					          sub s2 a3 a1 	 			          # subtrai y1 - y0
					          ABS(s2)       			          # pega o valor absoluto dessa subtração

					          # s3 = a0 < a2 ? 1 : -1
					          slt s3 a0 a2
					          slli s3 s3 1
					          addi s3 s3 -1

					          # s4 = a1 < a2 ? 1 : -1
					          slt s4 a1 a3
					          slli s4 s4 1
					          addi s4 s4 -1

					          bgt s1 s2  atribui            # abs(x1 - x0) > abs(y1 - y0) ?
					          sub s5 zero s2			          # - abs(y1 - y0) para deixar negativo
					          srai s5 s5 1 				          # divide - abs(y1 - y0) por 2
					          j loop1

atribui:            srai s5 s1 1                  # divide abs(x1 - x0) por 2

loop1:              li t1 320
										mul t1 a1 t1
					          add t1 t1 a0
					          add t1 t1 t0
					          sb a4 (t1)

					          bne a0 a2 calcula
					          bne a1 a3 calcula

                    lw s5 16(sp)
					          lw s4 12(sp)
					          lw s3  8(sp)
					          lw s2  4(sp)
					          lw s1  0(sp)
					          addi sp sp 20
					          ret

calcula:            mv t5 s5
					          sub t6 zero s1
					          ble t5 t6 proximo
					          sub s5 s5 s2
					          add a0 a0 s3

proximo:            bge t5 s2 loop1
					          add s5 s5 s1
					          add a1 a1 s4
					          j loop1

