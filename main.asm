                    .data

N:                  .word 7
C:                  .space 160
c_lower:            .space 160
D:                  .space 1600
array:              .space 1600
z:                  .float 0.0
lowest:             .float 9999999999999.9
lowest_array:       .space 84
possible_array:     .space 84
                    .word 0
arrei:              .word 1 2 3 4 5 6 0

                    .text

                    .include "macros2.s"
                    .include "macros.asm"
                    M_SetEcall(exceptionHandling)

main:               la t0 N
                    lw a0 (t0)
                    la a1 C
                    call sorteio

                    li a0 0xff
                    call paint

                    la t0 N
                    lw a0 (t0)
                    la a1 C
                    call rotas

                    # call print_matrix

                    lw a0 N
                    la a1 arrei
                    call permutation

                    la t0 lowest
                    flw fa0 (t0)
                    li a7 2
                    M_Ecall

                    li a7 11
                    li a0 10
                    M_Ecall


                    la t0 N
                    lw s3 (t0)
                    la s4 lowest_array
                    la s1 C

                    # a0 = x0
										# a1 = y0
										# a2 = x1
										# a3 = y1
										# a4 = cor

loopa1:             beq s3 zero saii
                    lw t2 0(s4)

                    slli t2 t2 3
                    add t2 t2 s1                  # t2 c + slli 3
                    lw a0 0(t2)                   # a0 = x0
                    lw a1 4(t2)                   # a1 = y0

                    lw t2 4(s4)
                    slli t2 t2 3
                    add t2 t2 s1                  # t2 c + slli 3
                    lw a2 0(t2)                   # a0 = x0
                    lw a3 4(t2)                   # a1 = y0

                    #li a7 1
                    #M_Ecall

                    li a4 0x07

                    call line
                    lw a0 0(s4)
                    li a7 1
                    M_Ecall
                    li a0 9
                    li a7 11
                    M_Ecall

                    addi s3 s3 -1
                    addi s4 s4 4

                    j loopa1
saii:
                    la t0 N
                    lw a0 (t0)
                    la a1 C
                    call desenha

                    li a7 10
                    M_Ecall

                    # fn (u32, [u32, u32])
                    # a0: number of elements
                    # a1: pointer to the elements
sorteio:            slli t0 a0 1                  # multiply counter by 2 (each element is 64b)
                    mv t2 a1                      # save base address
                    li a7 41                      # random number syscall code (won't change)

loop:               addi t0 t0 -2                 # decrement element count
                    slli t1 t0 2                  # calculate address offset
                    add t1 t1 t2                  # calculate adddress

                    li a0 0                       # reset seed selector
                    li a1 310                     # set upper bound
                    M_Ecall                       # generate random number
                    rem a0, a0, a1
                    ABS a0

                    # li a7, 1
                    # M_Ecall

                    # li a7, 10
                    # M_Ecall

                    sw a0 0(t1)                   # store random number

                    li a0 0                       # reset seed selector
                    li a1 230                     # set upper bound
                    M_Ecall                         # generate random number
                    rem a0, a0, a1
                    ABS a0
                    sw a0 4(t1)                   # store random number

                    bnez t0 loop                  # are we done yet?
                    ret                           # yes we are!!

                    # fn (u32, [u32, u32])
                    # a0: number of elements
                    # a1: pointer to the elements
desenha:            slli t0 a0 1                  # multiply counter by 2 (each element is 64b)
                    mv t1 a1                      # save base address
                    li a7 111                     # print char on bitmap display code

loop2:              addi t0 t0 -2                 # decrement element count
                    slli t2 t0 2                  # calculate address offset
                    add t2 t1 t2                  # calculate adddress

                    srai a0 t0 1                  # get element index
                    addi a0 a0 65                 # calculate char
                    lw a1 0(t2)                   # get x position
                    lw a2 4(t2)                   # get y position
                    li a3 0x3800                  # set color (black font on green bg)
                    li a4 0                       # use frame 0
                    M_Ecall                         # print char

                    bnez t0 loop2                 # are we done yet?
                    ret                           # yes we are!!

                    # fn (u8)
                    # a0: color used to paint the display
paint:              li t0 0xff000000              # base display address
                    li t1 76800                   # number of pixels on the display (320x240)
                    add t1 t0 t1                  # end display address (base + pixels)
                    slli t2 a0 8
                    or a0 a0 t2
                    slli t2 a0 16
                    or a0 a0 t2
loop3:              sw a0 (t0)                    # paint pixel
                    addi t0 t0 4                  # increment address
                    blt t0 t1 loop3               # are we done yet?
                    ret                           # yes we are!!

                    # fn (u32, [u32, u32])
                    # a0: number of elements
                    # a1: pointer to the elements
rotas:              addi sp sp -20
                    sw ra  0(sp)
                    sw s1  4(sp)
                    sw s2  8(sp)
                    sw s3 12(sp)
                    sw s4 16(sp)

                    mv s4 a1
                    slli s1 a0 3                  # get the size of the list (in bytes)
                    add s1 s1 a1                  # final address of the list
                    mv s2 a1                      # copy list address

loop4:              mv s3 s2                      # element pointer for inner loop

loop5:              lw a0 0(s2)                   # x for current element from outer loop
                    lw a1 4(s2)                   # y for current element from outer loop
                    lw a2 0(s3)                   # x for current element from inner loop
                    lw a3 4(s3)                   # y for current element from inner loop
                    li a4 0x00                    # set line color (black)
                    call line

                    lw a0 0(s2)                   # x for current element from outer loop
                    lw a1 4(s2)                   # y for current element from outer loop
                    lw a2 0(s3)                   # x for current element from inner loop
                    lw a3 4(s3)                   # y for current element from inner loop
                    call distancia

                    sub t0 s2 s4                  # inner loop offset
                    sub t1 s3 s4                  # outer loop offset
                    srai t0 t0 3                  # inner loop position
                    srai t1 t1 3                  # outer loop position

                    la t2 D
                    li t3 20

                    mul t4 t3 t1
                    add t4 t4 t0
                    slli t4 t4 2
                    add t4 t4 t2
                    fsw fa0 (t4)

                    mul t4 t3 t0
                    add t4 t4 t1
                    slli t4 t4 2
                    add t4 t4 t2
                    fsw fa0 (t4)

                    addi s3 s3 8                  # point to the next element
                    blt s3 s1 loop5               # inner loop check

                    addi s2 s2 8                  # increment outer loop counter
                    blt s2 s1 loop4               # outer loop check

                    lw s4 16(sp)
                    lw s3 12(sp)
                    lw s2  8(sp)
                    lw s1  4(sp)
                    lw ra  0(sp)
                    addi sp sp 20
                    ret

                    # fn (u32, u32, u8)
                    # a0: x
                    # a1: y
                    # a2: color
                    # address = display + y * 320 + x = display + (y << 8) + (y << 6) + x
paint_pixel:        li t0 0xff000000              # get base address for the display
                    slli t1 a1 8                  # t1 = y * (2 ^ 8) = y << 8
                    slli t2 a1 6                  # t2 = y * (2 ^ 6) = y << 6
                    add t1 t2 t1                  # t1 = y * 320
                    add t1 t1 a0                  # offset
                    add t0 t0 t1                  # get final address
                    sb a2 (t0)                    # paint pixel
                    ret

                    # fn (i32, i32, i32, i32)
                    # a0: x0
                    # a1: y0
                    # a2: x1
                    # a3: y1
distancia:          sub t0 a0 a2
                    mul t0 t0 t0
                    sub t1 a1 a3
                    mul t1 t1 t1
                    add t0 t0 t1
                    fcvt.s.w ft0 t0
                    fsqrt.s fa0 ft0
                    ret

                    # fn ()
print_matrix:       la t0 D
                    li t1 0
                    li t2 0
                    li t3 20
                    lw t5 N

pm_loop:            mul t4 t2 t3                  # line offset
                    add t4 t4 t1                  # total offset
                    slli t4 t4 2                  # offset in bytes
                    add t4 t4 t0                  # final address
                    flw fa0 (t4)
                    li a7 2
                    M_Ecall

                    li a0 ' '
                    li a7 11
                    M_Ecall

                    addi t1 t1 1
                    blt t1 t5 pm_loop

                    li a0 10
                    li a7 11
                    M_Ecall

                    li t1 0
                    addi t2 t2 1
                    blt t2 t5 pm_loop

                    ret

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

                    # fn (i32, [i32])
                    # a0: number of elements on the array
                    # a1: array of values to permutate
permutation:        addi sp sp -20
                    sw ra  0(sp)
                    sw s0  4(sp)
                    sw s1  8(sp)
                    sw s2 12(sp)

                    mv s0 a0                      # coloca size em s0
                    mv s1 a1                      # coloca array em s1
                    mv t3 s0                      # coloca size em t3 para fazer o loop do show
                    li s2 0                       # s2 = i

olokinho:           mv a1 s1
                    la tp possible_array

show:               #li a7, 1                      # printa o rolê
                    lw a0 0(a1)
                    #M_Ecall

                    lw t2 -4(a1)
                    sw t2 0(tp)
                    li a2 20
                    mul t2 t2 a2
                    add t2 t2 a0
                    slli t2 t2 2
                    la a2 D
                    add t2 t2 a2
                    flw ft0 (t2)
                    fadd.s fa0 ft0 fa0

                    addi t3 t3 -1
                    addi a1 a1 4
                    addi tp tp 4
                    bne t3 zero show

                    slli a0 a0 2
                    la t0 D
                    add t0 a0 t0
                    flw ft0 (t0)
                    fadd.s fa0 ft0 fa0

                    addi a1 s1 -4
                    call update_path

                    la t3 z
                    flw fa0 (t3)
                    flw ft0 (t3)
                    mv t3 s0                      # coloca size em t3 para fazer o loop do show

while:              bge s2 s0 exit                # se i >= 3 sai do loop
                    slli t4 s2 2                  # t4 = i * 4
                    la t0 array                   # pega o array da memoria
                    add t0 t0 t4
                    lw t4 0(t0)                   # t4 = c[i]
                    bge t4 s2 pula
                    li a7 2
                    rem a7 s2 a7
                    bne a7 zero impar
                    mv a0 s1                      # a0 = endereco de A[0]
                    slli t4 s2 2
                    add a1 s1 t4                  # a1 = endereco de A[i]
                    lw t5 0(a0)
                    lw t6 0(a1)
                    sw t6 0(a0)
                    sw t5 0(a1)
                    j continua

impar:              slli t4 t4 2
                    add t4 s1 t4                  # t4 = A[c[i]]
                    mv a0 t4                      # a0 = endereco de A[c[i]]
                    slli t4 s2 2
                    add a1 s1 t4                  # a1 = endereco de A[i]
                    lw t5 0(a0)
                    lw t6 0(a1)
                    sw t6 0(a0)
                    sw t5 0(a1)

continua:           slli t4 s2 2                  # t4 = i * 4
                    la t0 array                   # pega o array da memoria
                    add t0 t0 t4
                    lw t4 0(t0)                   # t4 = c[i]
                    addi t4 t4 1
                    sw t4 0(t0)
                    add s2 zero zero
                    j olokinho

pula:               sw zero 0(t0)
                    addi s2 s2 1
                    j while

exit:               lw ra  0(sp)
                    lw s0  4(sp)
                    lw s1  8(sp)
                    lw s2 12(sp)
                    addi sp sp 20
                    ret

update_path:        la t0 lowest
                    flw ft0 (t0)
                    flt.s t1 fa0 ft0
                    la tp possible_array
                    la a6 lowest_array
                    li a7 21
                    beqz t1 end
                    fsw fa0 (t0)
loopinho:           beq a7 zero end
                    lw a5 0(tp)
                    sw a5 0(a6)
                    addi tp tp 4
                    addi a6 a6 4
                    addi a7 a7 -1
                    j loopinho

end:                ret


                    .include "SYSTEMv13.s"
