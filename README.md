```diff
- This is a fork to implement boundary conditions and a spin ladder unit cell.
```

# StochasticSeriesExpansion
[![Docs dev](https://img.shields.io/badge/docs-latest-blue.svg)](https://lukas.weber.science/StochasticSeriesExpansion.jl/dev/)
[![Docs stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://lukas.weber.science/StochasticSeriesExpansion.jl/stable/)
[![CI](https://github.com/lukas-weber/StochasticSeriesExpansion.jl/actions/workflows/main.yml/badge.svg)](https://github.com/lukas-weber/StochasticSeriesExpansion.jl/actions/workflows/main.yml)
[![codecov](https://codecov.io/gh/lukas-weber/StochasticSeriesExpansion.jl/graph/badge.svg?token=A0X9300H5S)](https://codecov.io/gh/lukas-weber/StochasticSeriesExpansion.jl)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.13993853.svg)](https://doi.org/10.5281/zenodo.13993853)


This is a state-of-the-art implementation of the stochastic series expansion quantum Monte Carlo (QMC) algorithm [[1]](#1) with abstract loop updates [[2]](#2), which allow
the efficient simulation of many different bosonic lattice models in different computational bases using the same code.

StochasticSeriesExpansion is aimed both at
* **Nonspecialists** who want to produce unbiased QMC data for comparison against experiments or other methods,
and
* **Specialists** who want to extend it to study novel models and phenomena.

Out of the box, it can simulate common quantum magnet Hamiltonians, but it can be easily extended to arbitrary models by providing a bond Hamiltonian matrix.

It is built on the [Carlo](https://github.com/lukas-weber/Carlo.jl.git) framework.

## Getting started

To start, install Carlo.jl and StochasticSeriesExpansion.jl in Julia
```julia
using Pkg
Pkg.add("Carlo")
Pkg.add("StochasticSeriesExpansion")
```

## References
<a id="1">[1]</a> A. W. Sandvik, Phys. Rev. B **59**, R14157(R) (1999)

<a id="2">[2]</a> L. Weber, A. Honecker, B. Normand, P. Corboz, F. Mila, S. Wessel, SciPost Phys. **12**, 054 (2022)
