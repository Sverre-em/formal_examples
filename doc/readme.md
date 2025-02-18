# Formal Verification Examples

This repo holds examples of how to do formal verification.

Examples of psl and formal and different patterns.

## How to run

`podman run -i -t --rm -v .:/fpga ghcr.io/sverrham/bookworm/formal:24.11 bash`

This run s the formal docker and mounts the current folder . to /fpga in the docker.

Then to run formal
`sby --yosys "yosys -m ghdl" -f <file>.sby`
