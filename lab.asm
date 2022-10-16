.data
    promptDividend: .asciiz "\nEnter the number to be divided: "
    promptDivisor: .asciiz "\nEnter the number divisor: "
    inSecondFinished: .asciiz "\nIn second finished "
    result: .asciiz "\nQuotient is: "
    menuPrompt: .asciiz "\nEnter (1) to do another calculation, (2) to exit the program: "
    line: .asciiz "\n"

.text

    main:
    
        li $v0, 4
        la $a0, promptDividend
        syscall

        li $v0, 5
        syscall

        move $s0, $v0 # dividend

        beq $s0, $zero, exit

        li $v0, 4
        la $a0, promptDivisor
        syscall

        li $v0, 5
        syscall

        move $s1, $v0 # divisor

        beq $s1, $zero, exit

        move $a0, $s0 # dividend
        move $a1, $s1 # divisor

        addi $s5, $zero, 0

        jal recursiveDivision

        exitRec:
            li $v0, 4
            la $a0, result
            syscall

            li $v0, 1
            move $a0, $s5
            syscall

            li $v0, 4
            la $a0, line
            syscall

        jal menu

        exit:
            li $v0, 10
            syscall
 
    recursiveDivision:

        addi $sp, $sp, -12
        # sw $s5, 12($sp)
        sw $s1, 8($sp)
        sw $s0, 4($sp)
        sw $ra, 0($sp)

        li $v0, 1
        # beq $s0, $zero, recursionDone
        blt $s0, $s1, recursionDone
        beq $s1, $zero, recursionDone

        move $s0, $a0 # dividend
        move $s1, $a1 # divisor

        sub $s0, $s0, $s1
        move $a0, $s0
        move $a1, $s1
        jal recursiveDivision

        addi $s5, $s5, 1

        recursionDone:
            lw $ra, 0($sp)
            lw $s0, 4($sp)
            lw $s1, 8($sp)
            # lw $s5, 12($sp)
            addi $sp, $sp, 12

            jr $ra

        # addi $s2, $s2, 1
        # move $s0, $a0 # dividend
        # move $s1, $a1 # divisor

        # sub $s0, $s0, $s1

        # move $a0, $s0
        # move $a1, $s1

        # sub $s4, $s0, $s1
        # # addi $s4, $s0, -3
        # bge $s4, $zero, recursiveDivision

        # beq $s1, $zero, exitRec
        # beq $s0, $zero, exitRec

        # jr $ra

    menu: 
        li $v0, 4
        la $a0, menuPrompt
        syscall

        li $v0, 5
        syscall

        move $s3, $v0

        beq $s3, 1, main
        beq $s3, 2, exit