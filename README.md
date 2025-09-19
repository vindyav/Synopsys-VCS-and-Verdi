# VCS and Verdi Simulation Guide

This repository provides a comprehensive step-by-step manual for compiling, running, and debugging Verilog code using **Synopsys VCS** and **Verdi**. The guide is suitable for students and engineers practicing digital design and verification flows in industry-standard environments.

---

## Contents

- `VCS-and-Verdi.pdf` — Main documentation on setup, commands, and example Verilog modules.
    - Environment setup instructions
    - How to compile and simulate with VCS
    - Debugging with Verdi GUI (waveform viewing)
    - Sample code for basic gates and flip-flops
    - Full adder Verilog example and testbench
    - Waveform generation and export procedures

---

## Quick Start

1. **Environment Setup**
    - Load Synopsys environment variables and tool setup scripts as explained in the PDF.
2. **Compile Design**
    - Use provided VCS commands to compile your Verilog files (e.g. `vcs -full64 yourtb.v -debug_access+all -lca -kdb`).
3. **Run Simulation**
    - Execute the compiled simulation with `.simv` and prepare waveforms for Verdi.
4. **Debug with Verdi**
    - Open the waveform `.fsdb` in Verdi: `verdi -ssf novas.fsdb -nologo`
    - Add signals and explore results interactively as illustrated in the guide.

See the PDF for command descriptions, usage variants, and troubleshooting.

---

## Example Designs (In progess)

The document includes code and testbenches for:
- Basic logic gates (NOT, OR, AND, NAND, NOR, XOR, XNOR)
- Common flip-flops (SR, JK, D, T)
- Full adder

---

## License

"For academic use only"

---

## Acknowledgments

Developed for use with Synopsys tools for Verilog simulation and debugging in academic/industrial digital design flows.
