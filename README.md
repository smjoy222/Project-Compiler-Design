# Project Compiler Design

A simple compiler built using **Flex (Lex)** and **Bison (Yacc)** that supports a **C-like language with Bangla keywords**.  
This project demonstrates lexical analysis, parsing, symbol table management, and execution of basic control structures.


## ✨ Features

  ✅ Supports variable declarations for **int** and **float**<br>
  ✅ Assignment and evaluation of arithmetic expressions<br>
  ✅ Print variables using Bangla keyword **`dekhau`**<br>
  ✅ Conditional statements using Bangla keywords  <br>
   **`jodi`** → `if`  <br>
    **`notuba`** → `else`  <br>
  ✅ Loop constructs  <br>
   **`jonno`** → `for`  <br>
   **`jokhon`** → `while`  <br>
  ✅ Basic symbol table implementation with type checking  <br>
  ✅ Error handling for undeclared variables, type mismatches, and division by zero  <br>
  

## 📂 Project Structure
Project-Compiler-Design<br>
│<br>
├── lexer.l   &nbsp;&nbsp;&nbsp;**#Lexical analyzer (Flex)**<br>
├── parser.y  &nbsp;&nbsp;&nbsp;**#Syntax analyzer (Bison)**<br>
├── test.tab.h &nbsp;&nbsp;&nbsp; **#Generated Bison header**<br>
├── test.tab.c &nbsp;&nbsp;&nbsp;**#Generated Bison parser**<br>
├── lex.yy.c   &nbsp;&nbsp;&nbsp;**#Generated Flex scanner**<br>
├── a.out      &nbsp;&nbsp;&nbsp;**#Executable after compilation**<br>
└── README.md  &nbsp;&nbsp;&nbsp;**#Project documentation**<br>

## ⚡Bangla Keywords 
| Bangla Keyword | Equivalent in C |
| -------------- | --------------- |
| `jodi`         | `if`            |
| `notuba`       | `else`          |
| `jonno`        | `for`           |
| `jokhon`       | `while`         |
| `dekhau`       | `printf`        |


## 🔧 Installation & Usage
1️⃣ **Requirements**<br>
Make sure you have **Flex** and **Bison** installed.<br>

2️⃣ **Build the Compiler**<br>
Run the following commands:<br>
flex lexer.l<br>
bison -d parser.y<br>
gcc lex.yy.c test.tab.c -o compiler<br>

3️⃣ **Run the Compiler**<br>
./compiler < program.txt<br>


## 🌟 Diagram (Flowchart)<br>
<img width="400" height="500" alt="image" src="https://github.com/user-attachments/assets/c60befd1-7ca0-4d6e-9515-31d30c21f92d" />


## 📜 Example Program

**Input (program.txt):** <br>

   int x, y;<br>
   float z;<br>

   x = 5;<br>
   y = 10;<br>
   z = 2.5;<br>

   dekhau x;<br>
   dekhau y;<br>
   dekhau z;<br>

   jodi (x < y) {<br>
       dekhau y;<br>
   } notuba {<br>
      dekhau x;<br>
   }<br>

   jonno (x = 0; x < 3; x = x + 1) {<br>
         dekhau x;<br>
   }<br>



**Output:**<br>

Variable declare kora holo: x<br>
Variable declare kora holo: y<br>
Variable declare kora holo: z<br>
Rakha holo: x te maan: 5<br>
Rakha holo: y te maan: 10<br>
Rakha holo: z te maan: 2.50<br>
Dekhano Hocche: x = 5<br>
Dekhano Hocche: y = 10<br>
Dekhano Hocche: z = 2.50<br>
Jodi-(if) executed (condition shotto)<br>
Dekhano Hocche: y = 10<br>
For executed<br>
Dekhano Hocche: x = 0<br>
Dekhano Hocche: x = 1<br>
Dekhano Hocche: x = 2<br>
<br>
<br>

## 👨‍💻 Author: [Sazzad Mahmud Joy](https://github.com/smjoy222)

