# Matrix Multiply Accelerator

## Overview
This project is aimed to speed up matrix multiplication and compare the speed using C

### Pipelining
Within the MAC (Multiply-Accumulate), there are 3 registers, allowing for a 3-stage pipeline. While the accumulator is adding the previous number, the mutiplier is already multiplying the next numbers.

### Systolic Arrays
The accelerator utilizes systolic arrays to speed up and parallelize the process.
