; Author: Matthew Wenzel
; Last Modified: 6/5/22
;
; Description:  Program that prompts a user to enter 10 numbers that are saved in the form of strings.
;		These strings are then converted to integers and saved to an array with the ReadString procedure
;		WriteVal procedure is then used to convert integers back to strings so that they can be printed to console. 
;				 

INCLUDE Irvine32.inc

; -------------------------------------------------------
; name: mDisplayString
; description: takes a string as a parameter and prints to console
; pre-conditions: parameters passed to the macro
; post-conditions: none
; receives: string_input
; returns: prints string to console
; -------------------------------------------------------
mDisplayString	MACRO	string_input
	push	edx
	
	mov		edx,	string_input
	call	WriteString
	
	pop		edx
ENDM

; -------------------------------------------------------
; name: mGetString
; description: prompts the user to enter a number which is saved as a string 
; pre-conditions: parameters passed to the macro
; post-conditions: user's string and string length saved to output location
; receives: parameters input_prompt, and a buffer for how long the user's string can be
; returns: output location for user's string, length of user's string
; -------------------------------------------------------
mGetString MACRO input_prompt, len_allowed, output_location, str_len	
	push	eax
	push	ecx
	push	edx
	
	mDisplayString	input_prompt		

	mov		edx,	output_location	
	mov		ecx,	len_allowed
	call	ReadString
	
	mov		str_len,	eax

	pop		eax
	pop		ecx
	pop		edx
ENDM


.data
num_Array			SDWORD		10	DUP(?)
user_str			BYTE		12	DUP(0)
output_str			BYTE		12	DUP(0)
inputstr_len		DWORD		?
array_sum			SDWORD		?
comma				BYTE		", ",0
program_title		BYTE		"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",0 
author_text			BYTE		"Written by: Matthew Wenzel",0
instructions_1		BYTE		"Please provide 10 signed decimal integers.",0
instructions_2		BYTE		"Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting the raw numbers",0
instructions_3		BYTE		"I will display a list of the integers, their sum, and their average value.",0
number_prompt		BYTE		"Please enter an signed number: ",0
error_text			BYTE		"ERROR: You did not enter a signed number or your number was too big.",0
error_prompt		BYTE		"Please try again: ",0
display_text		BYTE		"You entered the following numbers:",0
sum_text			BYTE		"The sum of these numbers is: ",0
avg_text			BYTE		"The truncated average is: ",0
closing_message		BYTE		"Thanks for playing!",0


.code

main PROC

; Display program title, author, and instructions 
	mDisplayString	OFFSET program_title								
	call	CrLf
	mDisplayString	OFFSET author_text				
	call	CrLf					
	call	CrLf
	mDisplayString	OFFSET instructions_1							
	call	CrLf
	mDisplayString	OFFSET instructions_2									
	call	CrLf
	mDisplayString	OFFSET instructions_3								
	call	CrLf
	call	CrLf					


; loop to gather string input from user which is converted to integers and added to array
	mov		ecx, 10
	mov		edi, OFFSET num_Array
_get_user_input:
		push	edi							
		push	OFFSET error_prompt			
		push	OFFSET error_text			
		push	OFFSET user_str				
		push	SIZEOF user_str				
		push	OFFSET inputstr_len			
		push	OFFSET number_prompt			
		call	ReadVal	
		add		edi, 4
	loop	_get_user_input
	call	CrLf


; Display the array 											
	mDisplayString	OFFSET	display_text	
	call	CrLf
	mov		ecx, 10
	mov		esi, OFFSET num_Array	
_display_array:
		push	[esi]
		push	OFFSET output_str
		call	WriteVal
		mDisplayString	OFFSET	comma
		add		esi, 4			
		loop	_display_array
	call	CrLf


; Calculate and display sum	
	mov		esi, OFFSET num_Array
	mov		ecx, 10
	mov		eax, 0
_calculate_sum:
		add		eax, [esi]
		add		esi, 4
		loop	_calculate_sum
		mov		array_sum, eax
	mDisplayString	OFFSET sum_text
	push	eax
	push	OFFSET output_str
	call	WriteVal
	call	CrLf


; calculate and display average
	mDisplayString	OFFSET avg_text
	mov		eax,	array_sum
	cdq
	mov		ebx,	10
	idiv	ebx
	push	eax
	push	OFFSET output_str
	call	WriteVal


; Display closing message
	call	CrLf
	call	CrLF
	mDisplayString	OFFSET closing_message
	call	CrLf
	

	Invoke ExitProcess, 0	        ; exit 

main ENDP


; -------------------------------------------------------
; name: ReadVal
; description: takes a number as a string and converts it to a signed integer.
; This integer value is then saved to an array.
; pre-conditions: prompts and array have been created
; post-conditions: none
; receives:	edi register, error_prompt, error_text, user_str, 				
; SIZEOF user_str, inputstr_len, number_prompt		
; returns: saves value to array 
; -------------------------------------------------------
ReadVal PROC

	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi


	mGetString [ebp + 8], [ebp + 16], [ebp + 20], [ebp + 12]		; call mGetString macro to get user input
	


_check_first_char:
	mov		esi, [ebp + 20]			; move user str to esi
	mov		ebx, 0					; clear ebx to hold integer val
	mov		ecx, [ebp + 12]			; set loop counter to string length
	lodsb	
	cmp		al,	43					; check if first char is '+' sign
	je		_check_next
	cmp		al,	45					; check if first char is '-' sign
	je		_neg_check_next		
	

	
_positive_str:
		cmp		al,	48				; make sure char is 0 - 9
		jl		_not_number
		cmp		al, 57
		jg		_not_number
		sub		al, 48				; subtract 48 to get number value
		push	eax
		mov		eax, ebx			
		mov		edx, 10
		mul		edx					; multiply int by 10
		jo		_pop_eax_error
		mov		ebx, eax			
		pop		eax
		movzx	edx, al				
		add		ebx, edx			; add result to count
		jo		_not_number
	_check_next:
	lodsb
	loop	_positive_str
	jmp		_save_num



_negative_str:
		cmp		al, 48				; make sure char is 0 - 9
		jl		_not_number
		cmp		al, 57
		jg		_not_number
		sub		al, 48				; subtract by 48 to get number value 
		push	eax
		mov		eax, ebx			
		mov		edx, 10
		imul	edx					; multiply int by 10
		jo		_pop_eax_error
		mov		ebx, eax			
		pop		eax
		movzx	edx, al				
		sub		ebx, edx			; add result to count
		jo		_not_number
	_neg_check_next:
	lodsb
	loop	_negative_str


	_save_num:
	; save number to array 
	mov		edi, [ebp + 32]			
	mov		[edi], ebx				

	pop		edi
	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	pop		ebp
	ret		28


_pop_eax_error:
	; display error and repeat prompt, as well as pop EAX that was pushed prior to error
	pop		eax	
_not_number:
	; display error message and re-prompt user for number imput
	mDisplayString	[ebp + 24]
	call	CrLf
	mGetString	[ebp + 28], [ebp + 16], [ebp + 20], [ebp + 12]
	jmp		_check_first_char


ReadVal ENDP

; -------------------------------------------------------
; name: WriteVal
; description: takes a signed integer and output string as parameters.
; converts the integer to a string stored in the output location and prints it to console. 
; pre-conditions: number and string are initialized and passed as parameters
; post-conditions: number value is printed to console as string 
; receives: output string and input number to be converted
; returns: prints string to console
; -------------------------------------------------------
WriteVal PROC
	push	ebp						
	mov		ebp, esp					
	push	eax
	push	edi
	push	ecx
	push	edx
	push	ebx
										
	mov		eax, [ebp + 12]			; save number into eax
	mov		edi, [ebp + 8]			; save output string in edi	
	
	cmp		eax, 0
	jge		_convert_number			; start conversion if positive
	neg		eax						; convert to positive if negative
	push	eax
	mov		al, 45					; store negative sign at start of string 
	stosb	
	pop		eax


	_convert_number:
	mov		ecx, 0					; set ecx as digit counter, becomes loop counter for _pop_and_store
		_loop:
		inc		ecx					; increment digit count
		mov		edx, 0	
		mov		ebx, 10
		div		ebx
		add		edx, 48				; add 48 to remainder to convert to ASCII
		push	edx					; push value to stack to be popped and stored later	
		cmp		eax, 0
		jne		_loop	
		

	_pop_and_store:
		pop		eax					; pops stack and stores each val in string 
		stosb							
		loop	_pop_and_store

		mov		al, 0				; add a zero to the end of the string
		stosb											 				
		mDisplayString [ebp + 8]	; display completed string

	pop		eax
	pop		edi
	pop		ecx
	pop		edx
	pop		ebx												
	pop		ebp												
	ret		8 					
WriteVal ENDP

END main
