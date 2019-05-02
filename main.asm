.data
N: .word 6
C: .space 160

.text

.include "macros2.s"
.include "macros.asm"
M_SetEcall(exceptionHandling)

main:     la t0 N
          lw a0 (t0)
          la a1 C
          jal sorteio

          li a0 0xff
          jal paint

          la t0 N
          lw a0 (t0)
          la a1 C
          jal rotas

          la t0 N
          lw a0 (t0)
          la a1 C
          jal desenha

          li a7 10
          ecall

# fn (i32, [i32, i32]) -> ()
# a0: number of elements
# a1: pointer to the elements
sorteio:  slli t0 a0 1            # multiply counter by 2 (each element is 64b)
          mv t2 a1                # save base address
          li a7 42                # random number syscall code (won't change)

loop:     addi t0 t0 -2           # decrement element count
          slli t1 t0 2            # calculate address offset
          add t1 t1 t2            # calculate adddress

          li a0 0                 # reset seed selector
          li a1 310               # set upper bound
          ecall                   # generate random number
          sw a0 0(t1)             # store random number

          li a0 0                 # reset seed selector
          li a1 230               # set upper bound
          ecall                   # generate random number
          sw a0 4(t1)             # store random number

          bnez t0 loop            # are we done yet?
          ret                     # yes we are!!

# fn (i32, [i32, i32]) -> ()
# a0: number of elements
# a1: pointer to the elements
desenha:  slli t0 a0 1            # multiply counter by 2 (each element is 64b)
          mv t1 a1                # save base address
          li a7 111               # print char on bitmap display code

loop2:    addi t0 t0 -2           # decrement element count
          slli t2 t0 2            # calculate address offset
          add t2 t1 t2            # calculate adddress

          srai a0 t0 1            # get element index
          addi a0 a0 65           # calculate char
          lw a1 0(t2)             # get x position
          lw a2 4(t2)             # get y position
          li a3 0x3800            # set color (black font on green bg)
          li a4 0                 # use frame 0
          ecall                   # print char

          bnez t0 loop2           # are we done yet?
          ret                     # yes we are!!

# fn (u8) -> ()
# a0: color used to paint the display
paint:    li t0 0xff000000        # base display address
          li t1 76800             # number of pixels on the display (320x240)
          add t1 t0 t1            # end display address (base + pixels)
          slli t2 a0 8
          or a0 a0 t2
          slli t2 a0 16
          or a0 a0 t2
loop3:    sw a0 (t0)              # paint pixel
          addi t0 t0 4            # increment address
          blt t0 t1 loop3         # are we done yet?
          ret                     # yes we are!!

# fn (i32, [i32, i32]) -> ()
# a0: number of elements
# a1: pointer to the elements
rotas:    addi sp sp 16
          sw ra  0(sp)
          sw s3  4(sp)
          sw s4  8(sp)
          sw s5 12(sp)

          slli s3 a0 3            # get the size of the list (in bytes)
          add s3 s3 a1            # final address of the list
          mv s4 a1                # copy list address

loop4:    mv s5 s4                # element pointer for inner loop

loop5:    lw a0 0(s4)             # x for current element from outer loop
          lw a1 4(s4)             # y for current element from outer loop
          lw a2 0(s5)             # x for current element from inner loop
          lw a3 4(s5)             # y for current element from inner loop
          jal Line

          addi s5 s5 8            # point to the next element
          blt s5 s3 loop5         # inner loop check

          addi s4 s4 8            # increment outer loop counter
          blt s4 s3 loop4         # outer loop check

          lw s5 12(sp)
          lw s4  8(sp)
          lw s3  4(sp)
          lw ra  0(sp)
          addi sp sp 16
          ret

# a0: x
# a1: y
# a2: color
# address = display + y * 320 + x = display + (y << 8) + (y << 6) + x
paint_pixel:  li t0 0xff000000    # get base address for the display
              slli t1 a1 8        # t1 = y * (2 ^ 8) = y << 8
              slli t2 a1 6        # t2 = y * (2 ^ 6) = y << 6
              add t1 t2 t1        # t1 = y * 320
              add t1 t1 a0        # offset
              add t0 t0 t1        # get final address
              sb a2 (t0)          # paint pixel
              ret


.include "SYSTEMv13.s"
.include "line.asm"
