.data 

array:              .word 0,2,1,0

matrix:             .float 0.0,5.0,8.0,
                           5.0,0.0,9.0,
                           8.0,9.0,0.0

sum:                .float 0.0

.text
                    
#a0 = array
#a1 = matrix
#a2 = size
                    la a0 array
                    la a1 matrix
                    li a2 4
                    addi t2 a2 -1                 #t2 = n - 1
custo:            
                    beq a2 zero exit
                    addi a2 a2 -1
                    lw t0 0(a0)                   # t0 = start pointer
                    lw t1 4(a0)                   # t1 = end pointer
                    mul t0 t0 t2                  
                    add t3 t1 t0                  # t3 = endereco da matriz com linha t0 e coluna t1
                    slli t3 t3 2
                    add t3 t3 a1
                    flw ft0 0(t3)                   # ft0 = custo do caminho t0 <-> t1
                    fadd.s fa0 fa0 ft0
                    addi a0 a0 4
                    j custo
exit:
                    ret
