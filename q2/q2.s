.data
    fmt_int: .string "%d "
    fmt_nl:  .string "\n"
.text

.global main

main:
    #a0 is argc, a1 = argv
    #The first argument is the program name so n = argc - 1
    addi s0,a0,-1 #s0 = n
    blez s0, end_program 

    mv s11, a1 #save argv pointer base at s11

    #allocate space for ans s2 = n*4 bytes
    slli a0,s0,2
    call malloc
    mv s2,a0 #save the base address of ans arrat at s2

    #space for stack
    slli a0,s0,2
    call malloc
    mv s4,a0 #store the address of base stack pointer in s4


    slli a0, s0, 2
    call malloc
    mv  s6, a0 

    #start the input array iter
    li s3,0  #i=0 at s3

loop:
    bge s3,s0,loop_done
    #load argv[i+1]
    addi t0,s3,1
    slli t0,t0,3

    add t0,s11,t0

    ld a0,0(t0) #a0 = pointer to string argument

    call atoi  #convert string into int

    slli t1,s3,2
    add t1,s6,t1
    sw a0,0(t1)

    addi s3,s3,1
    j loop

loop_done:
    #start with the stack
    #s5 will be the stacks top index
    li s5,-1

    #loop from i = n-1 to 0
    addi s3, s0,-1


nge_loop:
    bltz s3, nge_done

    #load arr[i] into t2
    slli t1, s3,2
    add t1,s6,t1
    lw t2,0(t1)

while_loop:
    # !stack.empty() -> s5!=1
    li t0,-1
    beq s5, t0, while_done

    #load stack.top() nto t4
    slli t3, s5,2
    add t3,s4,t3
    lw t4, 0(t3)        # t4 = index stored on stack
    slli t5, t4, 2
    add t5, s6, t5
    lw t6, 0(t5)        # t6 = arr[t4] = arr[stack.top()]

    # arr[stack.top()] <= arr[i]

    # arr[stack.top()] > arr[i], we break the while loop
    bgt t6,t2,while_done

    #stack.pop()
    addi s5,s5,-1
    j while_loop


while_done:
    # put the ans in ans[i]
    # calculate the ans[i]
    slli t6,s3,2
    add t6,t6,s2

    # tack is empty so give -1
    li t0,-1
    beq s5,t0, stack_empty

    # result is top of stack
    sw t4, 0(t6)
    j push

stack_empty:
    li t0, -1
    sw t0, 0(t6)


push:
    #stack push i 
    addi s5,s5,1
    slli t3,s5,2
    add t3, s4,t3
    sw s3,0(t3)

    addi s3,s3,-1
    j nge_loop

nge_done:
    li s3,0

print_loop:
    bge s3, s0, print_done
    slli t0, s3, 2
    add t0, s2, t0
    lw a1, 0(t0)
    la a0, fmt_int
    call printf
    addi s3, s3, 1
    j print_loop

print_done:
    la a0, fmt_nl
    call printf

end_program:
    li a0, 0
    call exit


