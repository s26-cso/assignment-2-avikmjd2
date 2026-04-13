# Syscall numbers
# open   = 56
# read   = 63
# lseek  = 62
# write  = 64
# exit   = 93


.section .data
filename: .string "input.txt"
yes_msg: .string "Yes\n"
no_msg: .string "No\n"

.section .text
.global _start

_start:
    li a7, 56 #openat syscall
    li a0, -100 # AT_FDCWD
    la a1, filename
    li a2,0
    li a3,0
    ecall
    mv s0,a0    #s0 = fd


    #lseek get file length
    li a7,62
    mv a0,s0
    li a1,0
    li a2,2
    ecall
    mv s1,a0 #s1 = file length

    #set two pointer
    li s2,0
    addi s3,s1,-1 #end


loop:
    bge s2,s3, is_palindrome

    #seek to left, read 1byte
    li a7,62
    mv a0,s0
    mv a1,s2  #offset = left
    li a2,0 #SEEK_SET
    ecall

    addi sp,sp, -16
    li a7,63
    mv a0,s0
    mv a1,sp
    li a2,1
    ecall

    lb s4, 0(sp)  #s4 = ch_left
    addi sp,sp,1


    #seek to right, read 1 byte
    li      a7, 62
    mv      a0, s0
    mv      a1, s3          # offset = right
    li      a2, 0           # SEEK_SET
    ecall


    addi    sp, sp, -1
    li      a7, 63
    mv      a0, s0
    mv      a1, sp
    li      a2, 1
    ecall
    lb      s5, 0(sp)       # s5 = ch_right
    addi    sp, sp, 1



    bne     s4, s5, not_palindrome

    # move pointers 
    addi    s2, s2, 1       # left++
    addi    s3, s3, -1      # right--
    j       loop


is_palindrome:
    li      a7, 64          # write syscall
    li      a0, 1           # stdout
    la      a1, yes_msg
    li      a2, 4
    ecall
    j       done


not_palindrome:
    li      a7, 64
    li      a0, 1
    la      a1, no_msg
    li      a2, 3
    ecall


done:
    li      a7, 93
    li      a0, 0
    ecall


