.globl make_node

#struct node {
#int val 4bits + padding = 8 bits
#node* left
#node* right
# }
make_node:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)

    mv s0,a0
    li a0, 24
    call malloc


    sw s0, 0(a0) #val
    sd zero, 8(a0) #node left
    sd zero, 16(a0) #node right

    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp,sp,16
    #a0 still has the starting point o fthe node so we can safely return
    ret 


.globl insert

insert:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp) #root
    sd s1, 8(sp) #val

    mv s0,a0 #root
    mv s1, a1 #val

    bne s0,zero, .insert_notnull
    mv a0, s1 #arg1 val
    call make_node
    j .insert_done


.insert_notnull:
    lw t0, 0(s0) #t0 = root->val
    #if (val < root->val) -> go left
    bge s1,t0,.insert_right


.insert_left:
    ld a0, 8(s0)  #a0 = left root
    mv a1,s1  #a1=val
    call insert
    sd a0, 8(s0)
    j .insert_return_root

.insert_right:
    # if (val > root->val) → go right (ignore equal, no duplicates)
    lw   t0, 0(s0)        
    ble  s1, t0, .insert_return_root   # val == root->val, do nothing

    ld   a0, 16(s0)        # a0 = root->right
    mv   a1, s1
    call insert            # returns new right subtree root
    sd   a0, 16(s0)        # root->right = result

.insert_return_root:
    mv a0,s0

.insert_done:
    ld   ra,  24(sp)
    ld   s0,  16(sp)
    ld   s1,   8(sp)
    addi sp, sp, 32
    ret


.globl get

get:
    addi sp,sp,-32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    mv s0, a0
    mv s1,a1

    bne s0,zero, .get_notnull
    li a0,0
    j .get_done

.get_notnull:
    lw t0, 0(s0) #t0 = root->val
    #val==root-> val return root
    bne s1,t0, .get_notequal
    mv a0,s0
    j .get_done

.get_notequal:
    bge s1,t0, .get_right

.get_left:
    ld   a0, 8(s0)        
    mv   a1, s1
    call get
    j    .get_done

.get_right:
    ld   a0, 16(s0)
    mv   a1, s1
    call get

.get_done:
    ld   ra,  24(sp)
    ld   s0,  16(sp)
    ld   s1,   8(sp)
    addi sp, sp, 32
    ret




.globl getAtMost
getAtMost:
    addi sp, sp, -32
    sd   ra,  24(sp)
    sd   s0,  16(sp)
    sd   s1,   8(sp)
    sd   s2,   0(sp)

    mv   s0, a0
    mv   s1, a1

    beq  s1, zero, .gam_null

    lw   s2, 0(s1)

    beq  s2, s0, .gam_exact
    bgt  s2, s0, .gam_left

    mv   a0, s0
    ld   a1, 16(s1)
    call getAtMost
    li   t0, -1
    beq  a0, t0, .gam_current
    j    .gam_done

.gam_current:
    mv   a0, s2
    j    .gam_done

.gam_left:
    mv   a0, s0
    ld   a1, 8(s1)
    call getAtMost
    j    .gam_done

.gam_exact:
    mv   a0, s0
    j    .gam_done

.gam_null:
    li   a0, -1

.gam_done:
    ld   ra,  24(sp)
    ld   s0,  16(sp)
    ld   s1,   8(sp)
    ld   s2,   0(sp)
    addi sp, sp, 32
    ret