.data
start: .asciiz "Please input phrase to code/decode (29 character limit)\n"
ask: .asciiz "would you like to terminate the program? \n"
new_line:.asciiz  "\n"
.text
.globl my_main
my_main:
   li $s0,0x10010100 #load address mask
   li $s1,0x100100A0 #load the base adress of  array1(input string)
   li $s2,0x100100C0 #load the base adress of  array2(output string)
   li $s3,0x10010130 #load the base adress of array3(encryption code)
   li $t0,0x35393634    #store the encryption code
   sw $t0,0($s3)
   li $t0,0x38313330
   sw $t0,4($s3)
   li $t0,0x00003237
   sw $t0,8($s3)
  addi $s4,$0,48    #lower limit for number
  addi $s5,$0,57   #upper limit for number
  addi $s6,$0,89      #Y and
   addi $s7,$0,121 #y
  LOOP1:
   li $v0,4    #print start
   la $a0,start
   syscall
   li  $v0, 8           # read  string by using sys call
   add $a0, $0,$s1   # load first array address into $a0
   addi $a1, $0,29  #load the character limit
   syscall
   li $v0,4     #make new line
   la $a0,new_line
   syscall
   addi $t2,$0,0     #offset i
   LOOP2:
   add $t3,$t2,$s1     #current adress in respect to array1
   add $t4,$t2,$s2     #current adress in respect to array2
   lb $t5,0($t3)     #load element from array1[i]
   beq $0,$t5,done #jump to done if null character is pulled from array
    slt $t6,$t5,$s4      #is it less than 48?
    bne $t6,$0,continue
    slt $t6,$s5,$t5      #is it greater than 57?
    bne $t6,$0,continue
    or  $t7,$s0,$t5      #decrypt by reading adress in respect to the number ored with the mask in array3
    lb $t5,0($t7)
   continue:
   sb $t5,0($t4)     #store  into array 2[i]
   addi $t2,$t2,1     #increment i
    j,LOOP2
   done:
   li $t5,0x5C6D0000     #store \n and null chatacter into end of array
   addi $t4,$t4,1
   sb $t5,0($t4)
   li $v0,4     #print result
   or $a0,$s2,$0
   syscall
   li $v0,4     #make new line
   la $a0,new_line
   syscall
   li $v0,4  #ask to terminate
   la $a0,ask
   syscall
   li $v0,12     #read character
   syscall
   or $t8,$v0,$0
   li $v0,4      #make new line
   la $a0,new_line
   syscall
   beq $t8,$s6,finished #branch to finish if character is Y
   beq $t8,$s7,finished #branch to finish if character is y
   j,LOOP1 #branch to beginning loop if neither
   finished:
   li $v0,10     #exit program
   syscall
