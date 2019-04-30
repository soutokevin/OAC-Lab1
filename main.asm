.data
N: .word 6
C: .space 160

.text

main:    la t0 N
         lw a0 (t0)
         la a1 C
         jal sorteio

         li a7 10
         ecall

# fn (i32, *i32) -> ()
# a0: number of elements
# a1: pointer to the elements
sorteio: slli t0 a0 1            # multiply counter by 2 (each element is 64b)
         mv t2 a1                # save base address
         li a7 42                # random number syscall code (won't change)

loop:    addi t0 t0 -2           # decrement element count
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
