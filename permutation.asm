                    .data

array:              .word 0 0 0 0 0 0 0 0 0 0
                          0 0 0 0 0 0 0 0 0 0
arrei:              .word 3 1 2

                    .text

                    # a0 = n(size)
                    # a1 = array of any
                    li a0 3
                    la a1 arrei

permutation:        mv s0 a0                      # coloca size em s0
                    mv s1 a1                      # coloca array em s1
                    mv t3 s0                      # coloca size em t3 para fazer o loop do show
                    add t1 zero zero              # t1 = i
olokinho:           mv a1 s1
show:               li a7, 1                      # printa o rolê
                    lw a0 0(a1)
                    ecall
                    addi t3 t3 -1
                    addi a1 a1 4
                    bne t3 zero show
                    li a0 10
                    li a7 11
                    ecall
                    mv t3 s0                      # coloca size em t3 para fazer o loop do show
while:              bge t1 s0 exit                # se i >= 3 sai do loop
                    slli t4 t1 2                  # t4 = i * 4
                    la t0 array                   # pega o array da memoria
                    add t0 t0 t4
                    lw t4 0(t0)                   # t4 = c[i]
                    bge t4 t1 pula
                    li a7 2
                    rem a7 t1 a7
                    bne a7 zero impar
                    mv a0 s1                      # a0 = endereco de A[0]
                    slli t4 t1 2
                    add a1 s1 t4                  # a1 = endereco de A[i]
                    jal swap
                    j continua
impar:              slli t4 t4 2
                    add t4 s1 t4                  # t4 = A[c[i]]
                    mv a0 t4                      # a0 = endereco de A[c[i]]
                    slli t4 t1 2
                    add a1 s1 t4                  # a1 = endereco de A[i]
                    jal swap
continua:           slli t4 t1 2                  # t4 = i * 4
                    la t0 array                   # pega o array da memoria
                    add t0 t0 t4
                    lw t4 0(t0)                   # t4 = c[i]
                    addi t4 t4 1
                    sw t4 0(t0)
                    add t1 zero zero
                    j olokinho
pula:               sw zero 0(t0)
                    addi t1 t1 1
                    j while
swap:               lw t5 0(a0)
                    lw t6 0(a1)
                    sw t6 0(a0)
                    sw t5 0(a1)
exit:               ret
