.data
    line: .asciiz "\n --------------------------------------"
    nodeNumberLabel: .asciiz	"\n Node No.: "
    addressOfCurrentNodeLabel: .asciiz	"\n Address of Current Node: "
    addressOfNextNodeLabel: .asciiz	"\n Address of Next Node: "
    dataValueOfCurrentNode: .asciiz	"\n Data Value of Current Node: "
    promptSize: .asciiz "\n Enter the size of the linked list: "
    promptData: .asciiz "\n Enter the data of the node of the linked list: "
    userInput: .space 20
    inFirstFinished: .asciiz "\n In first finished "
    inSecondFinished: .asciiz "\n DENEME "
    reversedLinkedList: .asciiz "\n Reversed linked list: "

.text

    main:

        jal	createLinkedList
        move $s1, $v0 # s1 points to the first linked list
        move $s4, $v1 # size 1
        move $a0, $s1  
	    jal printLinkedList

        li $v0, 4
        la $a0, reversedLinkedList
        syscall

        move $a0, $s1 
        # move $a1, $s4 
        jal displayReverseOrderRecursive

        li $v0, 10
        syscall

    displayReverseOrderRecursive:

        addi $sp, $sp, -16
        sw $s3, 12($sp)
        # sw $s2, 12($sp)
        sw $s1, 8($sp)
        sw $s0, 4($sp)
        sw $ra, 0($sp)

        move $s1, $a0 # address of the linked list
        # move $s2, $a1 # size

        lw $s0, 0($s1) 
        lw $s3, 4($s1)

        # li $v0, 4
        # la $a0, inSecondFinished
        # syscall
        # li $v0, 1
        # move $a0, $s3
        # syscall

        li $v0, 1
        beq $s0, $zero, recursionDone
        
        addi $s1, $s1, 8
        # addi $s2, $s2, -1
        move $a0, $s1
        # move $a1, $s2
        jal displayReverseOrderRecursive

        lw $s3, 4($s1) # emin değilim..

        li $v0, 1
        move $a0, $s3
        syscall

        recursionDone:

            lw $ra, 0($sp)
            lw $s0, 4($sp)
            lw $s1, 8($sp)
            # lw $s2, 12($sp)
            lw $s3, 12($sp)
            addi $sp, $sp, 16

            jr $ra

    createLinkedList:

    li $v0, 4
    la $a0, promptSize
    syscall

    # get the size of the array
	li $v0, 5
    syscall

	addi $sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	

    move $s0, $v0 # transfer the size

	li	$s1, 1   

	li	$a0, 8 # Each node is 8 bytes: link field I data field.
	li	$v0, 9
	syscall

	move $s2, $v0 # beginning address of linked list	
	move $s3, $v0 # beginning address of linked list

    li $v0, 4
    la $a0, promptData
    syscall

    # get the data of the array
	li $v0, 5
    syscall

    move $s4, $v0 # s4 is the data of the of the first node

	sw	$s4, 4($s2)	# store it to the first node's data field
	
addNode:

	beq	$s1, $s0, allDone 
	addi $s1, $s1, 1 # counter	

	li	$a0, 8 # allocate 8 bytes
	li	$v0, 9 
	syscall
    # Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2) # the address of the new node ($v0) is stored into 0($s2), first part (link field) of the previous node
 
	move $s2, $v0	# address of the new node
	
    li $v0, 4
    la $a0, promptData
    syscall

    # get the size of the array
	li $v0, 5
    syscall

    move $s4, $v0 # s4 is the data of the of the first node

	sw	$s4, 4($s2)	# store it to the new node's data field
	j	addNode
allDone:
    # link field of the last node is 0!
    # The last node is pointed by $s2.
	sw	$zero, 0($s2)
	move $v0, $s3 # v0 now points to the beginning of the linked list	
    move $v1, $s0 # transfer size
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
#=========================================================

printLinkedList:
# Print linked list nodes in the following format
# --------------------------------------
# Node No: xxxx (dec)
# Address of Current Node: xxxx (hex)
# Address of Next Node: xxxx (hex)
# Data Value of Current Node: xxx (dec)
# --------------------------------------

	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	

	move $s0, $a0 # take the address of the linked list
	li   $s3, 0 # node counter

printNextNode:
	beq	$s0, $zero, printedAll 
	lw	$s1, 0($s0)	# load the address of the next node
	lw	$s2, 4($s0)	# laod the data of the current node
	addi $s3, $s3, 1 

	la	$a0, line
	li	$v0, 4
	syscall	
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move $a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move $a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move $a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.
	move $s0, $s1 # s1: address of the next node
	j	printNextNode
printedAll:

# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
#=========================================================