
	.equ speed1 , 0xF0000
	.equ speed2 , 0x8F00
	.equ speed3 , 0xFF0
	.text 
	.global main

main:	MOV r9,#3;  R9 will be used for the total no of elements in the list 
	
	BL seed;
	LDR R3,=init; TOP OF THE QUE
	MOV R4,R3; WILL BE BOTTOM OF THE QUE
	MOV R7,#0x5F;
	MOV R11,#0xFF; // this is the size of the que
	
	SWI 0x206; CLEAR SCREEN

	MOV R10,#240;
	STR R10,[R3],#4;
	MOV R10,#241;
	STR R10,[R3],#4;
	MOV R10,#242;
	STR R10,[R3];
	
	MOV R1,#8
	LDR R2,=star;
	MOV R0,#16;
	SWI 0X204;
	ADD R0,R0,#1;
	SWI 0X204;
	ADD R0,R0,#1;
	SWI 0X204;
	
	BL createbox;
	BL RANDOMPOINT;

start:	MOV R0,#0;
	SWI 0x203;
	CMP R0,#0;
	MOVNE R6,R0;
	BNE CHK;
	B start;

CHK: 	CLZ R5,R6;    cheking which key is pressed
	RSB R5,R5,#32;
	
	CMP R5,#2;
	BEQ TOP;

	CMP R5,#5;
	BEQ LEFT;
	
	CMP R5,#7;
	BEQ RIGHT;

	CMP R5,#10;
	BEQ BOT;

	B start;

TOP:	SUBS R11,R11,#1; if top key pressed then move snake ccordingly
	BLEQ COPYBACK;
	LDR R10,[R3];
	CMP R10,#32;
	BLT GAMEOVER;
	SUB R10,R10,#32;
	ADD R3,R3,#4;
	STR R10,[R3];
	BL intersection;
	BL Delay;
	BL DELETE;
	BL PRINT; 
	BL CHECKu;
	B TOP;

BOT:	SUBS R11,R11,#1;
	BLEQ COPYBACK;
	LDR R10,[R3];
	LDR R5,=385;
	CMP R10,R5;
	BGE GAMEOVER;
	ADD R10,R10,#32;
	ADD R3,R3,#4;
	STR R10,[R3];
	BL intersection;
	BL Delay;
	BL DELETE;
	BL PRINT;
	BL CHECKb;
	B BOT;

LEFT:	SUBS R11,R11,#1;
	BLEQ COPYBACK; circular ques
	LDR R10,[R3];
	MOV R8,R10, LSL #27;
	CMP R8,#0;
	BEQ GAMEOVER;
	SUB R10,R10,#1;
	ADD R3,R3,#4;
	STR R10,[R3];
	BL intersection;
	BL Delay;
	BL DELETE;
	BL PRINT;
	BL CHECKl;
	B LEFT;

RIGHT:	SUBS R11,R11,#1;
	BLEQ COPYBACK;
	LDR R10,[R3];
	AND R8,R10,#0X1F;
	CMP R8,#0X1F;
	BEQ GAMEOVER;
	ADD R10,R10,#1;
	ADD R3,R3,#4;
	STR R10,[R3];
	BL intersection;
	BL Delay;
	BL DELETE;
	BL PRINT;
	BL CHECKr;
	B RIGHT;

DELETE:	STMFD R13!,{LR};  to delete the tail
	LDR R2,=space;
	LDR R10,[R4];
	AND R0,R10,#0X1F;
	MOV R1,R10,LSR #5;
	ADD R1,R1,#1;
	SWI 0X204;
	ADD R4,R4,#4;
	LDMFD R13!,{PC};

PRINT:	STMFD R13!,{LR}; to add the head
	LDR R2,=star;
	LDR R10,[R3];
	AND R0,R10,#0X1F;
	MOV R1,R10,LSR #5;
	ADD R1,R1,#1;
	SWI 0X204;
	LDMFD R13!,{PC};
	
CHECKu:	STMFD R13!,{LR};  checking the codition for catch of food. if yes the add the head to top.
	LDR R10,[R3];
	CMP R10,R7;
	ADDEQ R9,R9,#1;
	SUBEQ R10,R10,#32;
	ADDEQ R3,R3,#4;
	STREQ R10,[R3];
	BLEQ PRINT;
	BLEQ RANDOMPOINT;
	MOV R0,#0;
	SWI 0x203;
	CMP R0,#0;
	MOVNE R6,R0;
	BNE CHK;
	LDMFD R13!,{PC};

CHECKb:	STMFD R13!,{LR};
	LDR R10,[R3];
	CMP R10,R7;
	ADDEQ R9,R9,#1;
	ADDEQ R10,R10,#32;
	ADDEQ R3,R3,#4;
	STREQ R10,[R3];
	BLEQ PRINT;
	BLEQ RANDOMPOINT;
	MOV R0,#0;
	SWI 0x203;
	CMP R0,#0;
	MOVNE R6,R0;
	BNE CHK;
	LDMFD R13!,{PC};

CHECKl:	STMFD R13!,{LR};
	LDR R10,[R3];
	CMP R10,R7;
	ADDEQ R9,R9,#1;
	SUBEQ R10,R10,#1;
	ADDEQ R3,R3,#4;
	STREQ R10,[R3];
	BLEQ PRINT;
	BLEQ RANDOMPOINT;
	MOV R0,#0;
	SWI 0x203;
	CMP R0,#0;
	MOVNE R6,R0;
	BNE CHK;
	LDMFD R13!,{PC};

CHECKr:	STMFD R13!,{LR};
	LDR R10,[R3];
	CMP R10,R7;
	ADDEQ R9,R9,#1;
	ADDEQ R10,R10,#1;
	ADDEQ R3,R3,#4;
	STREQ R10,[R3];
	BLEQ PRINT;
	BLEQ RANDOMPOINT;
	MOV R0,#0;
	SWI 0x203;
	CMP R0,#0;
	MOVNE R6,R0;
	BNE CHK;
	LDMFD R13!,{PC};



GAMEOVER:     @Gameover conditions
	LDR R2,=gameover;
	MOV R0,#0;
	MOV R1,#0;
	SWI 0x204;
	MOV R1,#1;
	LDR R2,=Cscore;
	SWI 0x204;
	MOV R2,R9; PRINTING THE VALUE OF SCORE
	MOV R0,#15;
	SWI 0x205;
	MOV R0,#0;
	
	BL gethighscore;
	CMP R9,R3;
	BLE prints;
	BLGT storehighscore;
	MOVGT R1,#2;
	LDRGT R2,=congo;
	MOVGT R0,#0;
	SWIGT 0X204;

	BL gethighscore;
prints:	MOV R0,#0;
	MOV R1,#3;
	LDR R2,=Hscore;
	SWI 0x204;
	MOV R2,R3;
	MOV R0,#24;
	SWI 0x205;
	

end:	SWI 0x11;

RANDOMPOINT:     @Random point Generation
	STMFD R13!,{R5,LR};
	BL seed;
	LDR R7,=rand;
	LDR R7,[R7];
	LDR R5,=0x1FF;
	AND R7,R7,R5;
	LDR R5,=404;
	CMP R7,R5;
	SUBGE R7,R7,#0xff;
	BL intersectionfood;
	LDR R2,=food;
	AND R0,R7,#0X1F;
	MOV R1,R7,LSR #5;
	ADD R1,R1,#1;
	SWI 0X204;
	LDMFD R13!,{R5,PC};


COPYBACK:STMFD R13!,{LR};
	MOV R5,R9; TEMPORAY CHANGED TO R5 HAVE TO CHANGE TO R9
	LDR R8,=init;
loopi:	LDR R6,[R4] ; back of the que goes to beginning 
	STR R6,[R8];
	ADD R8,R8,#4;
	ADD R4,R4,#4;
	SUB R5,R5,#1;
	CMP R5,#0;
	BNE loopi;
	SUB R3,R8,#4;

	LDR R4,=init;
	LDR R11,=0xFF;
	LDMFD R13!,{PC};

Delay:	STMFD R13!,{LR};
	CMP R9,#10
	MOVLE R6,#speed1;
	CMPGT R9,#20;
	MOVLE R6,#speed2;
	MOVGT R6,#speed3;
loopj:	CMP R6,#0;
	SUBNE R6,R6,#1;
	BNE loopj;
	LDMFD R13!,{PC};

createbox:
	STMFD R13!,{LR};
	MOV R0,#0;
	MOV R6,#32;
	LDR R2,=dash;
loopk:	MOV R1,#0;
	SWI 0X204;
	MOV R1,#14;
	SWI 0X204;
	SUB R6,R6,#1;
	ADD R0,R0,#1;
	CMP R6,#0;
	BNE loopk;

	@this part of the code is fo printing horizontal pipes
	MOV R1,#1;
	MOV R0,#32;
	MOV R6,#32;

	LDR R2,=pipe;
loopl:	SWI 0X204;
	SUB R6,R6,#1;
	ADD R1,R1,#1;
	CMP R6,#0;
	BNE loopl;

	LDMFD R13!,{PC};
	

seed:	STMFD R13!,{LR};     Making the food to appear in different places.
	LDR R6,=rand;
	SWI 0x6d; taking the ccurrent time
	STR R0,[R6];
	LDMFD R13!,{PC};
	

intersection:	@checking wheter snake intersects itself?
	STMFD R13!,{LR};
	MOV R5,R9; 
	LDR R10,[R3];
	MOV R12,R4;

loopm:	LDR R6,[R12],#4;
	CMP R6,R10;
	BEQ GAMEOVER;
	SUB R5,R5,#1;
	CMP R5,#0;
	BNE loopm;
	LDMFD R13!,{PC};

intersectionfood:     @checking whether food generated is intersecting with snake?
	STMFD R13!,{LR};
	MOV R5,R9; 
	LDR R10,[R3];
	MOV R12,R4;

loopn:	LDR R6,[R12],#4;
	CMP R6,R7;
	BLEQ seed;   if it intersects then generate a new value for seed and check again...
	BLEQ RANDOMPOINT;
	SUB R5,R5,#1;
	CMP R5,#0;
	BNE loopn;	
	LDMFD R13!,{PC};




storehighscore:
	STMFD R13!,{LR};
	LDR R0,=highscore;
	MOV R1,#1; output mode of file
	SWI 0x66;
	ldr R1,=OutFileHandle ; load input file handle
	str R0,[R1] ; save the file handle
	
	ldr R0,=OutFileHandle;
	ldr R0,[R0];
	mov R1,R9;
	swi 0X6b;
	MOV R3,R0;

	ldr r0,=OutFileHandle
	ldr r0,[r0]
	SWI 0x68
	LDMFD R13!,{PC};


gethighscore:
	STMFD R13!,{LR};
	LDR R0,=highscore;
	MOV R1,#0; input mode of file
	SWI 0x66;
	ldr R1,=InFileHandle; load input file handle
	str R0,[R1]; save the file handle
	
	ldr R0,=InFileHandle;
	LDR R0,[R0];
	BCS storehighscore;
	SWI 0X6c;
	MOV R3,R0;

	ldr R0,=InFileHandle;
	ldr R0,[R0];
	SWI 0x68;
	
	LDMFD R13!,{PC};


	.data
OutFileHandle: .word 0
InFileHandle: .word 0
chararray: .skip 80;
gameover: .asciz "The game is Over my boy !!!"
Cscore:	.asciz "Your score is "
Hscore:	.asciz "Highest score ever is "
congo: 	.asciz "You got a highscore Congrats :-)"

	 
space: 	.asciz " "	
star:	.asciz "*"
food:	.asciz "#"
dash:	.asciz "-"
pipe:	.asciz "|"
rand:	.word  80;

highscore: .asciz "HighScore.sha" ;
init: 	.word	


		
	.end

@ we will be usin R0 aka R5 for cols
@ we will be usin R1 aka R6 for rows
@ will use R8 to change the location of the pointer everytime