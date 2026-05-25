# Some interesting problems
These may not be strictly coding exercises, and some are purely theoretical.
Anyone interested is welcome to give them a try.
They are entirely optional, but highly encouraged for deeper understanding.

## 1. Proving that mux is universal
A mux can be used to realise many simple gates
For example, the two circuits shown below are completely equivalent functionally
<img width="1280" height="255" alt="photo_6097955148110958616_y" src="https://github.com/user-attachments/assets/073669d0-1231-4d6f-b5a2-940c506f7f8b" />
here the function implemented is (a&(~b))
In a similar way try to implement an *and* gate and a *not* gate
and now try to combine them

<img width="600" height="337" alt="DK" src="https://github.com/user-attachments/assets/d8327f7d-378e-4157-9485-b86a6022983e" />

Since we can make a universal gate with it , it is also a universal gate.

## 2. Dual edge triggered flipflop
Try the problem named 'dual-edge triggered flip-flop' in hdlbits
<img width="2092" height="586" alt="image" src="https://github.com/user-attachments/assets/892ffa13-5058-46c7-abb0-0d821147dd4e" />


## 3. Look-Up Table (LUT)

### Definition
A **Look-Up Table (LUT)** is a small memory that implements a Boolean function by storing the output for every possible input combination.

For a 2-input LUT, there are 2 inputs (A, B), so it stores 4 output values corresponding to all input combinations.

---

A 2-input LUT is defined by the following stored values:

| A | B | Output |
|---|---|--------|
| 0 | 0 | 1 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

---
1. Write the Boolean expression implemented by this LUT.  
2. Try drawing on paper how the circuit might look only using muxes
<details>
<summary>Hint</summary>
its sorta like binary search
</details>

This is how logic gates are actually implemented in a vast majority of FPGAs (Field Programmable Gate Arrays) , they contain a bajilion of these LUTs and programmable connections which realise the whole circuit.

## 4. Grey Code to binary code and vice versa and some properties of xor
Gray coding is a mapping in which each binary number is assigned a unique binary representation such that consecutive values differ by only one bit.

You might've encountered this in K-maps where you use the ordering <00 01 11 10> where we can see that all adjacent things only differ by 1 bit.

A formula for converting binary to grey is:  
- g3 = b3  
- g2 = b3 ^ b2  
- g1 =      b2 ^ b1  
- g0 =           b1 ^ b0
  
It can be generalised to n bits.  
Now your job is to invert these equations to convert binary to grey.  
<details>
<summary>Hint</summary>
x^y is equivalent to (x+y)mod2 so commutativity , associativity hold.

Also x^x=0
</details>






