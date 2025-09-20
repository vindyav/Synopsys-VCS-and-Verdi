# VCS and Verdi Guide

This repository documents step-by-step instructions for running simulation and debugging Verilog designs using [**Synopsys VCS and Verdi**](https://github.com/vindyav/Synopsys-VCS-and-Verdi/blob/main/VCS%20and%20Verdi.pdf).  
It includes setup commands, compilation flags, waveform generation, and example modules for common digital blocks.

## Repository Status

This project is **in progress**.  
Future updates will include more Verilog projects, practical testbenches, and simulation waveforms.

## Contents

- VCS and Verdi Setup (environment, compilation, debug, run)
- Example Verilog modules (logic gates, flip-flops, full adder)
- Stepwise simulation and waveform generation
- Saving waveforms and signal lists

## Usage

1. Set up Synopsys VCS/Verdi environment:
    ```
    source /path/to/Synopsys/SetupFiles/bashrc
    source /path/to/Synopsys/SetupFiles/vcssetup
    ```
2. Compile:
    ```
    vcs -full64 <testbench>.v -debugaccess+all -lca -kdb
    ```
3. Run simulation:
    ```
    ./simv
    verdi -ssf novas.fsdb -nologo
    ```

See the main PDF [VCS and Verdi Pdf](https://github.com/vindyav/Synopsys-VCS-and-Verdi/blob/main/VCS%20and%20Verdi.pdf) for complete details.

## Planned Additions

- Advanced projects coming soon

## Author

Namala Vindya Vahini  
MTech, ECE (VLSI specialization)  
Gmail: 212516002@ece.iiitp.ac.in

---

> For any issues or suggestions, feel free to open an issue to Gmail or submit a pull request!


