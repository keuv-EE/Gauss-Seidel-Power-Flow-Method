# Load Flow — Gauss-Seidel in MATLAB

This repository contains a MATLAB/Octave script for solving the power flow (load flow) problem in electrical power systems using the Gauss-Seidel iterative method.

The code is intended for academic purposes and allows simulation of a network with an arbitrary number of buses by manually entering the required data through the terminal.

## Features

- Input of the number of buses in the system.
- Reading of initial bus voltages.
- Reading of the nodal admittance matrix Y-bus.
- Input of specified bus powers.
- Definition of each bus type:
  - `PQ` — load bus;
  - `PV` — generation bus with controlled voltage.
- Iteration using the Gauss-Seidel method.
- Configurable convergence criteria for the real and imaginary parts of bus voltages.
- Printing of final bus voltages and iteration count.

## Notes

- Bus 1 is implicitly treated as the reference/slack bus, since the iterative loop starts at `i = 2`.
- The script uses manual terminal input for all data.
- There is no advanced data validation, CSV/file input, or graphical interface.

## Applications

- Power flow studies in power systems.
- Academic projects and courses in Electric Power Systems.
- Experiments with iterative methods for solving nonlinear equations.
- A base for improvements such as file-based data input, input validation, and comparison with methods such as Newton-Raphson.
