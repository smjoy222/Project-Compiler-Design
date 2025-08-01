# Project Compiler Design

A simple compiler built using **Flex (Lex)** and **Bison (Yacc)** that supports a **C-like language with Bangla keywords**.  
This project demonstrates lexical analysis, parsing, symbol table management, and execution of basic control structures.


## ✨ Features

  ✅ Supports variable declarations for **int** and **float**
  ✅ Assignment and evaluation of arithmetic expressions  
  ✅ Print variables using Bangla keyword **`dekhau`**
  ✅ Conditional statements using Bangla keywords  
   **`jodi`** → `if`  
    **`notuba`** → `else`  
  ✅ Loop constructs  
   **`jonno`** → `for`  
   **`jokhon`** → `while`  
  ✅ Basic symbol table implementation with type checking  
  ✅ Error handling for undeclared variables, type mismatches, and division by zero  


## 📂 Project Structure
Project-Compiler-Design/
│
├── lexer.l # Lexical analyzer (Flex)
├── parser.y # Syntax analyzer (Bison)
├── test.tab.h # Generated Bison header
├── test.tab.c # Generated Bison parser
├── lex.yy.c # Generated Flex scanner
├── a.out # Executable after compilation
└── README.md # Project documentation

##⚡Bangla Keywords
| Bangla Keyword | Equivalent in C |
| -------------- | --------------- |
| `jodi`         | `if`            |
| `notuba`       | `else`          |
| `jonno`        | `for`           |
| `jokhon`       | `while`         |
| `dekhau`       | `printf`        |


## 🔧 Installation & Usage
1️⃣ Requirements
Make sure you have **Flex** and **Bison** installed.

2️⃣ Build the Compiler
Run the following commands:
flex lexer.l
bison -d parser.y
gcc lex.yy.c test.tab.c -o compiler

3️⃣ Run the Compiler
./compiler < program.txt


🌟 Diagram (Flowchart)
<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/c60befd1-7ca0-4d6e-9515-31d30c21f92d" />


📜 Example Program
Input (program.txt):

   int x, y;
   float z;

   x = 5;
   y = 10;
   z = 2.5;

   dekhau x;
   dekhau y;
   dekhau z;

   jodi (x < y) {
       dekhau y;
   } notuba {
      dekhau x;
   }

   jonno (x = 0; x < 3; x = x + 1) {
         dekhau x;
   }


Output:
Variable declare kora holo: x
Variable declare kora holo: y
Variable declare kora holo: z
Rakha holo: x te maan: 5
Rakha holo: y te maan: 10
Rakha holo: z te maan: 2.50
Dekhano Hocche: x = 5
Dekhano Hocche: y = 10
Dekhano Hocche: z = 2.50
Jodi-(if) executed (condition shotto)
Dekhano Hocche: y = 10
For executed
Dekhano Hocche: x = 0
Dekhano Hocche: x = 1
Dekhano Hocche: x = 2



👨‍💻 Author
Sazzad Mahmud Joy
