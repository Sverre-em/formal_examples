# Formal Verification Examples

vhdl formal verification examples

Examples of psl and formal and different patterns.

## How to run

`podman run -i -t --rm -v .:/fpga ghcr.io/sverrham/bookworm/formal:24.11 bash`

This run s the formal docker and mounts the current folder . to /fpga in the docker.

Then to run formal
`sby --yosys "yosys -m ghdl" -f <file>.sby`


# Information from chatGPT

Common Solvers Used in SymbiYosys

    Yices2 (SMT solver)
    Boolector (SMT solver, optimized for bit-vectors)
    Z3 (General SMT solver, supports multiple theories)
    abc (Built-in AIG-based model checker in Yosys)
    CVC5 (Successor to CVC4, another SMT solver)

Each solver has different strengths:

    Boolector is highly optimized for bit-vectors.
    Yices2 supports efficient bit-blasting for integer arithmetic.
    Z3 is a general-purpose SMT solver with a wide range of logic support.
    abc is used for checking finite-state systems using SAT-based methods.

### Induction-Based Verification

Induction is a mathematical proof technique that works by proving that a property holds for all states of a system. In formal verification, it is used to prove safety properties.
What is Induction?

Induction consists of two main steps:

    Base Case (BMC - Bounded Model Checking)
        Show that the property holds in the initial state (cycle 0).
    Inductive Step (K-induction)
        Assume the property holds for k cycles and show that it must also hold for k+1.

If both steps succeed, then the property holds for all states in the design.

#### Using Induction in SymbiYosys

To use induction, the sby configuration file should specify prove mode with an induction-capable solver (like boolector, yices, or z3).

    mode prove activates inductive proof mode.
    smtbmc runs a SAT-based model checker (BMC + induction).
    The solver (boolector) is used for checking.

### Alternative to Induction

Instead of induction, you can use BMC (Bounded Model Checking) or Temporal Induction:

    BMC (Bounded Model Checking)
        Checks up to a fixed number of cycles but doesn’t prove properties indefinitely.
        Useful for finding counterexamples but not proving general correctness.

    Temporal Induction
        Uses past states to prove correctness of future states.
        Works well for liveness properties (e.g., “eventually, X must happen”).

When to Use Induction vs. BMC?

    Use Induction if you need to prove correctness for all states.
    Use BMC if you only care about finding bugs within a limited number of cycles.

Types of Properties in Formal Verification

Formal verification involves proving different types of properties about a design. The main categories include safety properties and liveness properties.

## 1. Safety Properties

    Definition: A safety property states that "something bad never happens."
    Example: "The counter never reaches 1010."
    Verification Approach:
        Bounded Model Checking (BMC) to check violations up to a certain depth.
        Inductive Proofs to prove correctness for all states.
        Property Directed Reachability (PDR) via ABC engine.

Example of a Safety Property

If you have a state machine where an invalid state should never be reached

`assert state /= ERROR_STATE report "Invalid state reached!" severity failure;`

This is a safety property because we want to ensure that ERROR_STATE never happens.

## 2. Liveness Properties

    Definition: A liveness property states that "something good eventually happens."
    Example: "The request signal will eventually lead to a response."
    Verification Approach:
        Cannot be proven with simple inductive proofs.
        Needs temporal logic or unrolling to ensure the property holds in the long run.

Example of a Liveness Property

If a request (req) signal should eventually generate an acknowledgment (ack):

`assert (req = '1') report "Request made, but no response!" severity failure;`

This alone does not prove the liveness property because we need to ensure ack happens at some future time.

Better Approach: Use Temporal Assertions (e.g., SystemVerilog Assertions or PSL) to say:

    "If req = 1, then ack = 1 should occur within N cycles."

## 3. Reachability Properties

    Definition: Ensures that a particular state can be reached.
    Example: "The counter will reach 1010 at some point."
    Verification Approach:
        Cover properties (cover in SymbiYosys).
        Used in formal test generation and coverage.

Example of a Reachability Property

If you want to check if the counter can reach 1010:
```
[cover]
depth 20
```

This tells the solver to check if there is any path that leads to the state "1010".

## 4. Temporal Properties

    Definition: Define properties over time (past/future states).
    Example: "Whenever req is asserted, ack must follow within 5 cycles."
    Verification Approach:
        Uses Linear Temporal Logic (LTL) or Computation Tree Logic (CTL).
        More common in model checking tools (e.g., NuSMV, PSL).

Example of a Temporal Property

    In PSL (Property Specification Language):

always (req -> eventually[0:5] ack);

    This states: "Whenever req goes high, ack must be high within 5 cycles."

Summary of Property Types

| Property Type | Meaning | Example |	How to Verify |
|-|-|-|-|
| Safety |	"Something bad never happens"|	Counter never reaches 1010|	BMC, Induction, PDR
| Liveness|	"Something good eventually happens"| Request leads to acknowledgment |Temporal logic, unrolling |
|Reachability|	"Can we get to this state?"|	Can counter reach 1010?|	Cover properties (cover)|
|Temporal|	"This must happen after that"|	req leads to ack in 5 cycles	|LTL, CTL, PSL|


## Comparison: Induction vs. Bounded Model Checking (BMC)
|Approach|	What It Does|	Pros|	Cons|
|-|-|-|-|
|Induction|	Proves correctness for all cycles|	Complete proof, works for infinite states|	Can fail if property isn't inductive|
|BMC|	Checks correctness up to N cycles|	Good for finding bugs|	Cannot prove correctness for all time|

#### Key Takeaways

    Induction proves that a property holds forever.
    Base case: Check property in the initial state.
    Inductive step: If it holds for k cycles, prove it holds for k+1.
    If both steps pass, the property is true for all time.

