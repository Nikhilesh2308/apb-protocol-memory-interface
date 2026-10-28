#!/usr/bin/env bash
set -euo pipefail
mkdir -p build
iverilog -g2012 -Wall -o build/apb_sim rtl/apb_memory_slave.v tb/tb_apb_memory_slave.v
vvp build/apb_sim
