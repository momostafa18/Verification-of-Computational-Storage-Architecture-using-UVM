# Introduction
  Common CPU’s, to make an operation (result = op1 (+/-/*/..) op2) on data saved in a memory. The host needs to 
    •	Send memory read command to read op1. 
    •	Send memory read command to read op2. 
    •	Send attended arithmetic command = op1 (+/-/*/..etc) op2 
    •	Send memory write to save result in another memory address. 
  Computation Storage architectures, allow the host to do this in one command
    •	send one commend with address 1 to read OP1, address 2 to read OP2, operation (add/sub/..etc), write address to store results. 
    •	The DUT internally will handle the whole operation. 
    Design Architecture
  So, the Design architecture is as shown in below figure 
  ![image](https://github.com/user-attachments/assets/7080877b-c867-437b-8034-52fc4e711785)
  
  The Design is a memory which performs four operations:
    1.	Read from the memory and output it to the port DQ
    2.	Write to the memory the value of the DQ
    3.	Get two values from the memory and add them and save them inside the memory
    4.	Get two values from the memory and subtract them and save them inside the memory
# Verification Environment for Computational Storage Architecture

  In our basic UVM architecture in the below figure, we have an active agent that drives the DUT and samples its behavior. 
  The sampled data is then sent to the scoreboard for functional checking against a golden model. Additionally, a subscriber collects coverage for analysis.
  ![image](https://github.com/user-attachments/assets/62fac1a1-f063-4cde-bb24-1ecbfaac3574)
# Test Cases

  So, our verification was to increase the confidence in the DUT, so we introduced the next test cases:
  
    1.	Read from the memory.
    2.	Write to the memory.
    3.	Add operation.
    4.	Subtract operation.
    5.	Read then write operation. 
    6.	Write then Read operation.
    7.	Read then Add operation.
    8.	Add then Read operation.
    9.	Read then subtract operation. 
    10.	Subtract then read operation.
    11.	Write then Add operation.
    12.	Add then Write operation.
    13.	Write then subtract operation.
    14.	Subtract then Write operation.
    15.	Add then subtract operation.
    16.	Subtract then Add operation.
    17.	DQ is ‘z’ when Add or SUB operations
  
  We depended on the constrained random verification to generate our stimulus 
 # Results
 
 ## Scoreboard
To check the memory contents against the expected values on the DQ or shall be stored in the memory , 
I created a memory_model in the interface which copies the contents of the DUT memory’s and checked through the scoreboard.

## Assertions
Assertion results can be found below
![image](https://github.com/user-attachments/assets/def47ce0-71a8-4b4a-9906-5640105c92b3)

## Coverage
Coverage Results can be found below 
###Code Coverage
    ![image](https://github.com/user-attachments/assets/d624e5f6-f237-4d65-b01b-760adf540a32)
###Functional Coverage
    ![image](https://github.com/user-attachments/assets/ce5a661f-04ae-49c8-85ce-2911e22f6a67)

