# Usecase: 
Used to Monitor Level of Fluids stored inside of Me Network
# Setup
1. Setup Computer with Adapter to ME Controller and Redstone I/O
2. Save Code onto the Computer.
3. Adjust desired liquids and their target threshould inside the Code.

 ```lua
 -- Targets
local TARGETS = {
  ["acetone"]={ 
    ["amount"]=32768000, -- 32_768_000
    ["side"]=sides.south},
  ["ethylene"]={
    ["amount"]=32768000, -- 32_768_000
    ["side"]=sides.east},
  ["woodvinegar"]={
    ["amount"]=32768000, -- 32_768_000
    ["side"]=sides.west},
  ["woodgas"]={
    ["amount"]=32768000, -- 32_768_000
    ["side"]=sides.west}
}
```

3. Run code by calling MangeMeFluids.
4. Hookup machines to respond the the Redstone signals emited.

# Example: GTNH Charcoal Byproduct Distillation
## Preview
<img width="300" height="400" alt="image" src="https://github.com/user-attachments/assets/9ffc9416-e8f6-4f6b-b370-0905a4ebcb42" /><br>
## Goal:
Maintain certain fluid levels of select results of distillation 
## Setup:
* Code and levels as described in the initial Setup
* Adapter adjacent to ME Controller and ComputerCase <br>
  <img width="800" height="400" alt="image" src="https://github.com/user-attachments/assets/9469211e-c062-48b0-94f8-6aa0065bcd46" /><br>
* Redstone I/O is connected to 3 cables from Project Red <br>
  <img width="400" height="300" alt="image" src="https://github.com/user-attachments/assets/070e9705-23da-4612-a9f6-85439a29bce3" /><br>
* Cables run to the 3 Distillation Towers equiped with "Machine Controller Covers", set to "Enable with Redstone" mode <br>
  <img width="800" height="400" alt="image" src="https://github.com/user-attachments/assets/73e298d3-a1c9-4c99-b998-f9bdb6f77032" />

