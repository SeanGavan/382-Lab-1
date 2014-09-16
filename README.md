382-Lab-1
=========

Objectives
----------
The objective of Lab 1 is to write the first complete assembly language program using what has been learned in class. The lab will give practice in using assemply to integrate higher-level if/then/else and looping constructs. To do so, the task is to write an assembly program that works as a four function calculator.

Preliminary design
------------------
The preliminary design with pseudocode can be found in the provided flowchart (flowchart.jpg) in the images folder.

Code
----
See "Calculator.asm" for the code w/ comments.

Debugging
---------
Subtract loop giving wrong result. Fix: reordered the compare instruction.  
Clear loop not able to declare a new first operand. Fix: more registers to hold future operands/operations.  
Maximum and minimum loops are passed over. Fix: reordered compare instruction.  
Multiply loop not decrementing second operand after the operation. Fix: decrement before operation.   
Multiply not returning zero when zero is an operand. Fix: added jump case for zero operand.  

Results
-------
Test: 0x11, 0x11, 0x11, 0x11, 0x11, 0x44, 0x22, 0x22, 0x22, 0x11, 0xCC, 0x55  
Result: 0x22, 0x33, 0x00, 0x00, 0xCC

Test: 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0xDD, 0x44, 0x08, 0x22, 0x09, 0x44, 0xFF, 0x22, 0xFD, 0x55  
Result: 0x22, 0x33, 0x44, 0xFF, 0x00, 0x00, 0x00, 0x02

Test: 0x22, 0x11, 0x22, 0x22, 0x33, 0x33, 0x08, 0x44, 0x08, 0x22, 0x09, 0x44, 0xff, 0x11, 0xff, 0x44, 0xcc, 0x33, 0x02, 0x33,        0x00, 0x44, 0x33, 0x33, 0x08, 0x55  
Result: 0x44, 0x11, 0x88, 0x00, 0x00, 0x00, 0xff, 0x00, 0xff, 0x00, 0x00, 0xff

Observations and Conclusions
----------------------------

Documentation
-------------
None.

