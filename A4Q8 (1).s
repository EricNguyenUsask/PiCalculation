.data
    strSingleForward: .asciiz "Single-precision forward order:"
    strDoubleForward: .asciiz "Double-precision forward order:"
    strSingleReverse: .asciiz "Single-precision reverse order:"
    strDoubleReverse: .asciiz "Double-precision reverse order:"

    cStart: .asciiz " (first "
    cEnd: .asciiz " fraction field bits correct)"

    piSingle: .float 3.14159265358979323846264338327950288419716939937510582097
    piDouble: .double 3.14159265358979323846264338327950288419716939937510582097

    # format of tests: | function | output | isDouble |
    tests: .word singleForward strSingleForward 0 doubleForward strDoubleForward 1 singleReverse strSingleReverse 0 doubleReverse strDoubleReverse 1 0
    testSizes: .word 10 51 100 501 1000 5001 10000 50001 100000 0

.text





singleForward:

    li $v0, 0               # use $v0 for n

    addi $t0,$zero,4
    mtc1 $t0,$f2
    cvt.s.w $f2,$f2       # use $f2 for top frac

    mtc1 $v0,$f3
    cvt.s.w $f3,$f3         # use $f3 for n as a floating point number


    addi $t0,$zero,2
    mtc1 $t0,$f5
    cvt.s.w $f5,$f5         # use $f5 for the floating point constant 2.0

    addi $t0,$zero,3
    mtc1 $t0,$f6
    cvt.s.w $f6,$f6         # use $f6 for the floating point constant 3.0

    addi $t0,$zero,4
    mtc1 $t0,$f7
    cvt.s.w $f7,$f7         # use $f7 for the floating point constant 4.0

    addi $t0,$zero,-1
    mtc1 $t0,$f8
    cvt.s.w $f8,$f8         # use $f8 for the floating point constant -1


    li $t1, 0               # constant sum of 0
    mtc1 $t1, $f9           # $f0 = current sum, estimated valur of pi if n big enough
    cvt.s.w $f9, $f9        # covert float step

    addi $a1, $a0, -1       #store k-1 into $a1


loop:

    bge $v0, $a1, done

    mul.s $f3, $f3, $f5     # multiply n by 2
    add.s $f10, $f3, $f5    # 2n + 2
    add.s $f11, $f3, $f6    # 2n + 3
    add.s $f12, $f3, $f7    # 2n + 4
    mul.s $f13, $f10, $f11  # (2n + 2).(2n + 3)
    mul.s $f14, $f13, $f12  # (2n + 2).(2n + 3).(2n + 4)

    div.s $f15, $f2, $f14   # calculate the fraction
    add.s $f9, $f9, $f15    # add current term into sum

    addi $v0,$v0,1          # add n by 1 each term

    
    mtc1 $v0,$f3
    cvt.s.w $f3,$f3

    mul.s $f2, $f2, $f8     # switch top of fraction between 4 and -4 after each term

    j loop

done: 
    add.s $f0, $f9, $f6     # add 3 to the fraction
    
    jr $ra






    

# Calculates the value of pi (double-precision) using the first k terms of Nilakantha's series.
# args: $a0 = k
# ret:  $f0 = calculated estimate of pi
doubleForward:
    li $v0, 0               # use $v0 for n

    mtc1 $v0,$f2
    cvt.d.w $f2,$f2         # use $f2 for n as a floating point number
 
    addi $t0,$zero,4
    mtc1 $t0,$f4
    cvt.d.w $f4,$f4         # use $f4 = 4 for top frac 

    addi $t0,$zero,2
    mtc1 $t0,$f6
    cvt.d.w $f6,$f6         # use $f6 for the floating point constant 2.0

    addi $t0,$zero,3
    mtc1 $t0,$f8
    cvt.d.w $f8,$f8         # use $f8 for the floating point constant 3.0

    addi $t0,$zero,4
    mtc1 $t0,$f10
    cvt.d.w $f10,$f10       # use $f10 for the floating point constant 4.0

    addi $t0,$zero,-1
    mtc1 $t0,$f12
    cvt.d.w $f12,$f12       # use $f12 for the floating point constant -1


    li $t1, 0               # constant sum of 0
    mtc1 $t1, $f14          # $f14 = current sum, estimated valur of pi if n big enough
    cvt.d.w $f14, $f14      # convert float step

    addi $a1, $a0, -1       #store k-1 into $a1


loop1:

    bge $v0, $a1, done1     # end when i get to k-1

    mul.d $f2, $f2, $f6     # multiply n by 2
    add.d $f16, $f2, $f6    # 2n + 2
    add.d $f18, $f2, $f8    # 2n + 3
    add.d $f20, $f2, $f10   # 2n + 4
    mul.d $f22, $f18, $f16  # (2n + 2).(2n + 3)
    mul.d $f24, $f22, $f20  # (2n + 2).(2n + 3).(2n + 4)

    div.d $f26, $f4, $f24  # calculate the fraction
    add.d $f14, $f14, $f26  # add current term into sum

    addi $v0,$v0,1          # add n by 1 each term

    mtc1 $v0,$f2
    cvt.d.w $f2,$f2

    mul.d $f4, $f4, $f12     # switch top of fraction between 4 and -4 after each term
    

    j loop1

done1: 
    add.d $f0, $f14, $f8     # add 3 to the fraction
    
    jr $ra







# Calculates the value of pi (single-precision) using the first k terms of Nilakantha's series added in reverse order.
# args: $a0 = k
# ret:  $f0 = calculated estimate of pi
singleReverse:

    li $v0, 0               # use $v0 for n
 

    addi $t0,$zero,1
    mtc1 $t0,$f4
    cvt.s.w $f4,$f4         # use $f4 for the floating point constant 1.0


    addi $t0,$zero,2
    mtc1 $t0,$f5
    cvt.s.w $f5,$f5         # use $f5 for the floating point constant 2.0

    addi $t0,$zero,3
    mtc1 $t0,$f6
    cvt.s.w $f6,$f6         # use $f6 for the floating point constant 3.0

    addi $t0,$zero,4
    mtc1 $t0,$f7
    cvt.s.w $f7,$f7         # use $f7 for the floating point constant 4.0

    addi $t0,$zero,-1
    mtc1 $t0,$f8
    cvt.s.w $f8,$f8         # use $f8 for the floating point constant -1

    addi $t0,$zero,4
    mtc1 $t0,$f20
    cvt.s.w $f20,$f20       # use $f20 for top frac 4

    addi $t0,$zero,-4
    mtc1 $t0,$f22
    cvt.s.w $f22,$f22       # use $f22 for top frac -4


    li $t1, 0               # constant sum of 0
    mtc1 $t1, $f9           # $f9 = current sum, estimated valur of pi if n big enough
    cvt.s.w $f9, $f9        # covert float step

    addi $a1, $a0, -1       #store k-1 into $a1
    mtc1 $a1,$f3
    cvt.s.w $f3,$f3         # $f3 = k -1 in float   




loop2:

    blt $a1,$zero, done2

    mul.s $f3, $f3, $f5     # multiply k - 1 by 2
    add.s $f10, $f3, $f5    # calculatate denominator
    add.s $f11, $f3, $f6    
    add.s $f12, $f3, $f7    
    mul.s $f13, $f10, $f11  
    mul.s $f14, $f13, $f12  # denominator store result in f14


    andi $t1, $a1, 1
    beqz $t1, is_even       #check in case k -1 is even

    div.s $f15, $f22, $f14  # calculate the fraction when k - 1 is odd
    add.s $f9, $f9, $f15    # add current term into sum

    addi $a1,$a1,-1         # decrease k - 1 by 1 each term

    mtc1 $a1,$f3
    cvt.s.w $f3,$f3

    j loop2

is_even:
 
    div.s $f15, $f20, $f14  # calculate the fraction when k - 1 is even
    add.s $f9, $f9, $f15    # add current term into sum

    addi $a1,$a1,-1         # decrease k - 1 by 1 each term

    mtc1 $a1,$f3
    cvt.s.w $f3,$f3  

    j loop2

done2: 
    add.s $f0, $f9, $f6     # add 3 to the fraction
    
    jr $ra


# Calculates the value of pi (double-precision) using the first k terms of Nilakantha's series added in reverse order.
# args: $a0 = k
# ret:  $f0 = calculated estimate of pi
doubleReverse:
    li $v0, 0               # use $v0 for n
 

    addi $t0,$zero,1
    mtc1 $t0,$f2
    cvt.d.w $f2,$f2         # use $f2 for the floating point constant 1.0


    addi $t0,$zero,2
    mtc1 $t0,$f4
    cvt.d.w $f4,$f4         # use $f4 for the floating point constant 2.0

    addi $t0,$zero,3
    mtc1 $t0,$f6
    cvt.d.w $f6,$f6         # use $f6 for the floating point constant 3.0

    addi $t0,$zero,4
    mtc1 $t0,$f8
    cvt.d.w $f8,$f8         # use $f8 for the floating point constant 4.0

    addi $t0,$zero,-1
    mtc1 $t0,$f10
    cvt.d.w $f10,$f10       # use $f10 for the floating point constant -1

    addi $t0,$zero,4
    mtc1 $t0,$f12
    cvt.d.w $f12,$f12       # use $f12 for top frac 4

    addi $t0,$zero,-4
    mtc1 $t0,$f14
    cvt.d.w $f14,$f14       # use $f14 for top frac -4


    li $t1, 0               # constant sum of 0
    mtc1 $t1, $f16          # $f16 = current sum, estimated valur of pi if n big enough
    cvt.d.w $f16, $f16      # covert float step

    addi $a1, $a0, -1       #store k-1 into $a1
    mtc1 $a1,$f18
    cvt.d.w $f18,$f18       # $f18 = k -1 in float   




loop3:

    blt $a1,$zero, done3

    mul.d $f18, $f18, $f4   # multiply k - 1 by 2
    add.d $f20, $f18, $f4   # calculatate denominator
    add.d $f22, $f18, $f6    
    add.d $f24, $f18, $f8    
    mul.d $f26, $f20, $f22  
    mul.d $f28, $f26, $f24  # denominator store result in f28


    andi $t1, $a1, 1
    beqz $t1, is_even2      #check in case k -1 is even

    div.d $f30, $f14, $f28  # calculate the fraction when k - 1 is odd
    add.d $f16, $f16, $f30  # add current term into sum

    addi $a1,$a1,-1         # decrease k - 1 by 1 each term

    mtc1 $a1,$f18
    cvt.d.w $f18,$f18

    j loop3

is_even2:
 
    div.d $f30, $f12, $f28  # calculate the fraction when k - 1 is even
    add.d $f16, $f16, $f30  # add current term into sum

    addi $a1,$a1,-1         # decrease k - 1 by 1 each term

    mtc1 $a1,$f18
    cvt.d.w $f18,$f18  

    j loop3

done3: 
    add.d $f0, $f16, $f6     # add 3 to the fraction
    
    jr $ra


## DO NOT MODIFY BELOW THIS LINE

main:
    la $s0, tests           # $s0 = pointer in tests
    mainLoop:
    lw $s1, 0($s0)          # $s1 = current function pointer
    beqz $s1, terminate
    li $v0, 11
    li, $a0, 10
    syscall
    lw $a0, 4($s0)
    li $v0, 4
    syscall
    lw $s2, 8($s0)          # $s2 = isDouble
    addi $s0, $s0, 12
    la $s3, testSizes       # $s3 = pointer in test sizes
    testLoop:
    lw $s4, 0($s3)          # $s4 = current test size
    addi $s3, $s3, 4
    beqz $s4, mainLoop
    li $v0, 11
    li, $a0, 10
    syscall
    move $a0, $s4
    li $v0, 1
    syscall
    li $v0, 11
    li, $a0, 9
    syscall
    move $a0, $s4
    jalr $ra, $s1
    bnez $s2, printDouble
    li $v0, 2
    mov.s $f12, $f0
    syscall
    li $v0, 4
    la $a0, cStart
    syscall
    jal checkBitsPiSingle
    move $a0, $v0
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, cEnd
    syscall
    b testLoop
    printDouble:
    li $v0, 3
    mov.d $f12, $f0
    syscall
    li $v0, 4
    la $a0, cStart
    syscall
    jal checkBitsPiDouble
    move $a0, $v0
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, cEnd
    syscall
    b testLoop

    terminate:
    li $v0, 10
    syscall

# Determines how many of the fractional field bits of a given single-precision float agree with the value of pi
# args: $f0 = single-precision value to check
# ret:  $v0 = count of bits (negative value indicates sign/exponent did not agree)
checkBitsPiSingle:
    li $v0, 0               # $v0 = sum
    li $t0, 0x80000000      # $t0 = highest order bit mask
    la $t1, piSingle
    lw $t1, 0($t1)
    mfc1 $t2, $f0
    checkLoopSingle:
    xor $t3, $t1, $t2
    and $t3, $t3, $t0
    bnez $t3 checkReturnSingle
    sll $t1, $t1, 1
    sll $t2, $t2, 1
    addi $v0, $v0 1
    bne $v0, 32 checkLoopSingle
    checkReturnSingle:
    addi $v0, $v0, -9
    jr $ra

# Determines how many of the fractional field bits of a given double-precision float agree with the value of pi (double-precision)
# args: $f0 = double-precision value to check
# ret:  $v0 = count of bits (negative value indicates sign/exponent did not agree)
checkBitsPiDouble:
    li $v0, 0
    li $t0, 0x80000000
    la $t1, piDouble
    lw $t1, 4($t1)
    mfc1 $t2, $f1
    checkLoopDouble:
    xor $t3, $t1, $t2
    and $t3, $t3, $t0
    bnez $t3 checkReturnDouble
    sll $t1, $t1, 1
    sll $t2, $t2, 1
    addi $v0, $v0 1
    bne $v0, 32 checkLoopDouble
    la $t1, piDouble
    lw $t1, 0($t1)
    mfc1 $t2, $f0
    lowerCheckLoopDouble:
    xor $t3, $t1, $t2
    and $t3, $t3, $t0
    bnez $t3 checkReturnDouble
    sll $t1, $t1, 1
    sll $t2, $t2, 1
    addi $v0, $v0 1
    bne $v0, 64 lowerCheckLoopDouble
    checkReturnDouble:
    addi $v0, $v0, -12
    jr $ra
