# Quick setup
We have 2 setups.

Firstly, all fst and fsti (excluding Sample.fst and TLS.Curve25519.fst) are imported from the Everycrypt directory of the HaclStar repos. These files are used in the makefile in conjuction with Sample.fst and TLS.Curve25519.fst (from mitls) in order to verify and generate the OCaml files. Generation of OCaml files.

Secondly, we have a dune file to import the hacl-star library from opam to build an executeable in conjuction with the main.ml file. To
build; dune build.
## Install
1. Opam install fstar
2. Opam install hacl-star
3. 