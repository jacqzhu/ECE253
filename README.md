# ECE253 Digital Systems Lab

This repository contains my implementations for ECE253 Labs, which includes SystemVerilog and RISC-V.
These labs explore memory-mapped I/O, polling, hardware timers, and interrupt control using RISC-V assembly and NIOS V.

### Verilog Labs
ALUs (Arithmetic Logic Units)
- Designed and simulated combinational logic circuits to perform arithmetic and logical operations.
- Validated functionality using waveform analysis in ModelSim.

FSM (Finite State Machines)
- Developed sequential circuits to detect binary input patterns using a 7-state FSM.
- Verified state transitions and timing behavior via simulation waveforms.

Counters
- Implemented synchronous and asynchronous counters in Verilog.
- Explored ripple and modular counter designs with variable bit widths.

### RISC-V Labs
I/O Polling & Timers
- Controlled on-board LEDs and pushbuttons via memory-mapped I/O.
- Designed a basic counter system with dynamic control based on user input.

Interrupt I/O
- Replaced polling with interrupt service routines (ISRs).
- Implemented preemptive control logic for responsive event handling.
