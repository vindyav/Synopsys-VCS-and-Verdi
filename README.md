# VCS and Verdi – Verilog Simulation and Debugging

This repository contains Verilog implementations and testbenches for fundamental digital circuits (gates, flip-flops, adders) along with step-by-step instructions to simulate and debug designs using **Synopsys VCS** and **Verdi**.

---

## 🚀 Features
- Gate-level circuits: **NOT, AND, OR, NAND, NOR, XOR, XNOR**
- Sequential circuits: **SR, JK, D, and T Flip-Flops**
- **Full Adder** design with testbench
- Waveform debugging with **Verdi** (`.fsdb` files)
- Commands for compiling, simulating, and debugging using **VCS**

---

## 🛠️ Tools Used
- **Synopsys VCS** – Simulation
- **Synopsys Verdi** – Waveform Debugging
- Linux shell environment

---

## 📂 Repository Structure
├── gates/
│ ├── not_gate.v
│ ├── not_gate_tb.v
│ ├── and_gate.v
│ ├── and_gate_tb.v
│ └── ...
├── flipflops/
│ ├── sr_ff.v
│ ├── sr_ff_tb.v
│ ├── jk_ff.v
│ └── ...
├── adder/
│ ├── full_adder.v
│ └── full_adder_tb.v
├── scripts/
│ └── vcs_commands.sh # compile/run/debug commands
└── README.md

yaml
Copy code

---

## ⚡ Quick Start

1. **Load environment:**
   ```bash
   source /home/SynopsysInstalledTools/SetupFiles/bashrc
   source /home/SynopsysInstalledTools/SetupFiles/vcs_setup
Compile design:

bash
Copy code
vcs -full64 full_adder_tb.v -debug_access+all -lca -kdb
Run simulation:

bash
Copy code
./simv verdi
Open waveforms in Verdi:

bash
Copy code
verdi -ssf novas.fsdb -nologo
📸 Waveform Debugging in Verdi
Inside Verdi GUI:

Go to Windows → Interactive Debug Mode

Simulation → Invoke Simulator

Simulation → Run and Continue

View → Signal List → Add to Waveform → New Waveform

👉 To save waveforms as images:
File → Capture Window → Save As (.png)

📜 Example Designs
Logic Gates: NOT, AND, OR, NAND, NOR, XOR, XNOR

Flip-Flops: SR, JK, D, T

Combinational: Full Adder

Each design includes:

Verilog source (.v)

Testbench (_tb.v)

Debug setup for VCS + Verdi

👤 Author
Namala Vindya Vahini

📧 vindya2102@gmail.com

🌐 LinkedIn

💻 GitHub
