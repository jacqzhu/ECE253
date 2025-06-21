# RISC-V Embedded I/O Labs

These projects are performed on the DE1-SoC Computer with Nios V using simulation of the computer system. 
CPUlator is a powerful and easy-to-use functional simulator that runs inside a web browser. It simulates the behavior of a whole computer system, including the processor, memory, and many types of I/O devices.

This repository contains my implementations for RISC-V embedded systems, focused on low-level firmware development for the DE1-SoC FPGA board.
These labs explore memory-mapped I/O, polling, hardware timers, and interrupt control using RISC-V assembly and NIOS V.

### Lab Overview
Lab 8 – Polling-Based I/O and Timers
- Controlled on-board LEDs and pushbuttons via memory-mapped I/O
- Implemented polling loops and hardware timer delays
- Designed a basic counter system with dynamic control based on user input

Lab 9 – Interrupt-Driven I/O
- Replaced polling with interrupt service routines (ISRs)
- Enabled real-time input/output using GPIO and timer interrupts
- Implemented preemptive control logic for responsive event handling
