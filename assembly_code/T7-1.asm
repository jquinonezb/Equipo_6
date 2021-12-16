.text
	addi $s2, $s2, 0 #ALU_o: 0
	addi $s0, $s0, 1 #ALU_o: 1
	addi $s1, $s1, 2 #ALU_o: 2
main:
	ori $s3,$s3, 0    #ALU_o: x
	beq $s2,$s3, else #ALU_o: x
if:
	addi $s0, $s0, 1 #ALU_o: 2, 3, 4, 5...
	j main 		 #ALU_o: x
else:
	addi $s1, $s1, 2 #ALU_o: 4, 6, 8, 10...
	j main 		 #ALU_o: x
