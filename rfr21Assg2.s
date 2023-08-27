#############################################                                         
#                                           #
#     Name: Assignment5                     #
#     Description: Calculate the sum, mean, #
#     min, max, and variance of a series    #
#     of numbers                            #
#     Date: October 19th, 2022              #
#     Author: Ryan Rowe                     #
#############################################
    .data
header: .asciiz "In this program, you will be prompted to enter 5 integers, and mathematical operations will be performed.\n"
prompt: .asciiz "Enter an integer: "
msg1:	.asciiz	"\nFloating Point List\n"
endl:	.asciiz "\n"
numsum: .asciiz "The sum of the numbers is: "
small:	.asciiz	"\nThe smallest number is: "
large:	.asciiz "\nThe largest number is: "
mean:	.asciiz "\nThe mean of the numbers is: "
variance: .asciiz "\nThe variance of the numbers is: "
    .text
    .globl main
myArray: .space 20			#space is 20 because each integer is 4 bits, there are 5 integers
main:
	#Printing out the header
	li $v0, 4				#I want to print out a message
	la $a0, header			#what message do I want to print? load address of header into $a0
	syscall		    		#execute the print

	#prompting user to enter integers, converting them to floating point,
	#and storing them into an array via a loop
	li $t0, 0				#setting $t0 to 0 (lower bound for the loop)
	li $t1, 5				#setting $t1 to 5 (upper bound for the loop)
	li $t2, 0				#setting $t2 to zero, represents the index of the array
startloop:					#starting the loop
	beq $t0, $t1, resetvals	#when t0==t1, we will exit the loop and reset $t0 and $t2
		li $v0, 4		#I want to print out a message
		la $a0, prompt	#what message do I want to print? load address of prompt into $a0
		syscall		    #execute the print
    	li $v0, 5		#tell syscall to read in an int
		syscall			#read in the int
		move $t3, $v0	#save the read int into $t3
		mtc1 $t3, $f1   #puts integer into floating point register
    	cvt.s.w $f1,$f1 #convert to floating point single
		s.s $f1, myArray($t2)	#storing $f1 @ position $t2 of myArray
		addi $t2, $t2, 4	#increment array position by 4
		addi $t0, $t0, 1	#increment $t0 by 1
	j startloop				#iterate through the loop again ('jump' to the top of loop)

resetvals:
	#resetting values for the next loop
	li $t0, 0				#setting $t0 to 0 (lower bound for the loop)
	li $t2, 0				#setting $t2 to zero, represents the index of the array
	li.s $f0, 0.0			#setting $f0 to 0
	li $v0, 4				#printing msg1
	la $a0, msg1
	syscall

startloop1:
	#printing the elements of the array and calculating the sum
	beq $t0, $t1, exitloop1
		li $v0, 2				#I want to print a float
    	lwc1 $f12, myArray($t2)	#store the value at position $t2 in a float regiester
		syscall					#print
		li $v0, 4				#I want to print a message
		la $a0, endl			#print endl
		syscall
		lwc1 $f1, myArray($t2)	#store the value at position $t2 in $f1
		add.s $f0, $f0, $f1
		addi $t2, $t2, 4		#increment array position by 4
		addi $t0, $t0, 1		#increment $t0 by 1
	j startloop1
exitloop1:
	li $v0, 4			#printing message numsum
	la $a0, numsum
	syscall
	li $v0, 2			#print a float
	mov.s $f12, $f0		#move the float in $f0 to $f12 register to print
	syscall				#print

resetvals1:
	#resetting values for the next loop
	li $t0, 0				#setting $t0 to 0 (lower bound for the loop)
	li $t2, 0				#setting $t2 to zero, represents the index of the array
	li $t1, 4				#changing $t1 to 4 because the loop calls for it
	lwc1 $f0, myArray($t2)	#store the first value in myArray in $f0

#finding the smallest number
startloop2:
	#finding and printing the smallest number
	beq $t0, $t1, printSmallest
		addi $t2, $t2, 4		#go to next element in myArray
		lwc1 $f1, myArray($t2)	#store the value at position $t2 in myArray -> $f1
		c.lt.s $f1, $f0			#checking if $f1 is less than $f0
		bc1t true				#if c1 is true, branch to true
		bc1f notTrue			#if c1 is false, branch to notTrue

true:
	mov.s $f0, $f1				#store the new lowest number ($f1) in $f0
	addi $t0, $t0, 1			#increment the loop
	j startloop2				#jump back into the loop

notTrue:
	addi $t0, $t0, 1			#increment the loop
	j startloop2				#jump back into the loop

printSmallest:
	#printing 'small' message
	li $v0, 4
	la $a0, small
	syscall
	#printing $f0
	li $v0, 2
	mov.s $f12, $f0
	syscall

resetvals2:
	#resetting values for the next loop
	li $t0, 0				#setting $t0 to 0 (lower bound for the loop)
	li $t2, 0				#setting $t2 to zero, represents the index of the array
	li $t1, 4				#changing $t1 to 4 because the loop calls for it
	lwc1 $f0, myArray($t2)	#store the first value in myArray in $f0

#finding the largest number
startloop3:
	#finding and printing the smallest number
	beq $t0, $t1, printLargest
		addi $t2, $t2, 4		#go to next element in myArray
		lwc1 $f1, myArray($t2)	#store the value at position $t2 in myArray -> $f1
		c.lt.s $f1, $f0			#checking if $f0 is greater than $f1
		bc1t notTrue1			#if c1 is true, branch to true
		bc1f true1				#if c1 is false, branch to notTrue

true1:
	mov.s $f0, $f1				#store the new greatest value in $f0
	addi $t0, $t0, 1			#increment loop by 1
	j startloop3				#jump back into the loop

notTrue1:
	addi $t0, $t0, 1			#increment loop by 1
	j startloop3				#jump back into the loop

printLargest:
	#printing 'large' message
	li $v0, 4
	la $a0, large
	syscall
	#printing $f0
	li $v0, 2
	mov.s $f12, $f0
	syscall

resetvals3:
	#resetting values for the next loop
	li $t0, 0				#setting $t0 to 0 (lower bound for the loop)
	li $t2, 0				#setting $t2 to zero, represents the index of the array
	li $t1, 5				#set $t1 to 5, as it was 4 before
	li.s $f0, 0.0			#setting $f0 to 0
	
#finding the mean
findmean:
	#finding the sum
	beq $t0, $t1, exitloop2
		lwc1 $f1, myArray($t2)	#store the value at position $t2 in $f1
		add.s $f0, $f0, $f1
		addi $t2, $t2, 4		#increment array position by 4
		addi $t0, $t0, 1		#increment $t0 by 1
	j findmean
exitloop2:
	#finding the mean
	li.s $f1, 5.0		#set $f1, the divisor, to 5.0
	div.s $f0, $f0, $f1	#divide $f0, the sum, by $f1, the number of floats
	li $v0, 4			#printing message mean
	la $a0, mean
	syscall
	li $v0, 2			#print a float
	mov.s $f12, $f0		#move the float in $f0 to $f12 register to print
	syscall				#print
	
resetvals4:
	#resetting values for the next loop
	li $t0, 0				#setting $t0 to 0 (lower bound for the loop)
	li $t1, 5				#set $t1 to 5, as it was 4 before
	li $t2, 0				#setting $t2 to zero, represents the index of the array
	#$f0 has the mean
	li.s $f1, 0.0			
	li.s $f2, 0.0
	li.s $f3, 4.0
#finding the variance
findvariance:
	#subtracting the mean from each number, squaring it, and adding it to the next
	beq $t0, $t1, getvariance
		lwc1 $f1, myArray($t2)
		sub.s $f1, $f1, $f0			#$f1 -= $f0
		mul.s $f1, $f1, $f1			#squaring $f1
		add.s $f2, $f2, $f1			#$f2 += $f1
		addi $t0, $t0, 1			#increment $t0 (loop) by 1
		addi $t2, $t2, 4			#increment $t2 (array pos) by 4
	j findvariance
getvariance:
	div.s $f2, $f2, $f3				#$f2 /= $f3; final step of finding the variance
	li $v0, 4						#print the 'variance' message
	la $a0, variance
	syscall
	li $v0, 2						#print a float
	mov.s $f12, $f2					#move the float in $f2 to $f12 register to print
	syscall							#print
jr $ra