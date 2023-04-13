# String to Integer Conversion and Display

## Author
Matthew Wenzel

## Description
This assembly language program prompts the user to enter 10 signed decimal integers as strings, which are then converted to their integer representation and stored in an array. The program then converts the integers back to strings and displays them on the console, along with their sum and truncated average.

## Requirements
- Irvine32.inc library

## How to Run
1. Assemble the program using an x86 assembler such as MASM.
2. Link the object file with the Irvine32 library.
3. Run the resulting executable.

## Program Structure
The program consists of a main procedure and two additional procedures, ReadVal and WriteVal.

### Main Procedure
The main procedure performs the following tasks:
1. Displays program title, author, and instructions.
2. Gathers user input as strings and converts them to signed integers using the ReadVal procedure, storing them in an array.
3. Displays the array of integers using the WriteVal procedure.
4. Calculates and displays the sum of the integers.
5. Calculates and displays the truncated average of the integers.
6. Displays a closing message and exits.

### ReadVal Procedure
ReadVal takes a string input from the user, converts it to a signed integer, and stores the integer in an array. It checks for invalid input and prompts the user to enter a valid number if necessary.

### WriteVal Procedure
WriteVal takes a signed integer and an output string as parameters, converts the integer to a string, and stores the string in the output location. It then prints the string to the console.

## Macros
The program includes two macros, mDisplayString and mGetString, which simplify string display and input retrieval, respectively.

### mDisplayString
Takes a string as a parameter and prints it to the console.

### mGetString
Prompts the user to enter a number which is saved as a string. The user's string and string length are saved to the output location.

## Data
The program uses several data elements for storing user input, output, and other necessary information. These include:
- num_Array: An array of signed double words (SDWORD) to store the 10 integer values.
- user_str: A byte array to store the user's input string.
- output_str: A byte array to store the output string for WriteVal.
- inputstr_len: A double word to store the length of the user's input string.
- array_sum: A signed double word to store the sum of the integers in the array.
- Several byte arrays for storing strings to be displayed as messages, prompts, and error texts.
