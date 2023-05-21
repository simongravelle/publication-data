# NMR Investigation of Water in Salt Crusts: Insights from Experiments and Molecular Simulations

Langmuir 2023, XXXX, XXX, XXX-XXX

Authors: Simon Gravelle, Sabina Haber-Pohlmeier, Carlos Mattea, Siegfried Stapf, Christian Holm, and Alexander Schlaich
Publication Date: May 19, 2023

This repository is associated with [our 2023 publication](https://doi.org/10.1021/acs.langmuir.3c00036) in Langmuir, in which we
investigate the properties of water confined withing salt crust using both NMR experiments and molecular dynamics simulations.

![alt text](figures/TOC.jpg)

### Data and script

Python and GROMACS scripts are hosted in the DaRUS repository of the university of Stuttgart: see here for
[bulk systems](https://doi.org/10.18419/darus-3179), and here for [slit pores](https://doi.org/10.18419/darus-3180).

## Our article in simple words

### Goals

This page describes the investigation we conducted as part of the SFB 1313, in collaboration 
with the experimental group of Ilmenau in Germany. The goals of the investigation were to:

- **better understand the properties of water confined within salt crusts**, which are disordered porous media made of salt,
- **combine NMR experiments**, which allow for probing the dynamics of water within a porous medium, **with molecular simulations**, a numerical method which allow to resolve the trajectories of water molecules, and their interaction with the salt surface.

### The particularity of salt crusts

When a fluid is in contact with a solid surface, its properties near the solid surface are modified. In general, the fluid viscosity, density, or dielectric permeability are different within a few nanometer distance from the surface, due to the solid-liquid interactions.

![alt text](figures/Context.png)

In the case were the solid surface is made of salt, as is the case for porous salt crusts, it creates a systems that is really unique, because salt is present within both the fluid, in the form of dissolved ions, and also constitute the solid surface. In addition, the adsorption of ions at the solid surface creates rough and locally charged landscape which in turn impacts the properties of water within the interface layer, as we will see below.