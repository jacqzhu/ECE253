# RISC-V Embedded I/O Labs

This repository contains my implementations for RISC-V embedded systems, focused on low-level firmware development for the DE1-SoC FPGA board.
These labs explore memory-mapped I/O, polling, hardware timers, and interrupt control using RISC-V assembly and NIOS V.

### Lab Overview
Polling I/O & Timers
- Controlled on-board LEDs and pushbuttons via memory-mapped I/O
- Implemented polling loops and hardware timer delays
- Designed a basic counter system with dynamic control based on user input

Interrupt I/O
- Replaced polling with interrupt service routines (ISRs)
- Enabled real-time input/output using GPIO and timer interrupts
- Implemented preemptive control logic for responsive event handling
