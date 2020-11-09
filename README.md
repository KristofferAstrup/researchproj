# Quick setup
We have 2 setups.

## Makefile using Evercrypt fst/fsti interfaces
Firstly, all fst and fsti (excluding Sample.fst and TLS.Curve25519.fst) are imported from the Everycrypt directory of the HaclStar repos. These files are used in the makefile in conjuction with Sample.fst and TLS.Curve25519.fst (from mitls) in order to verify and generate the OCaml files. Generation of OCaml files.
### Install
1. Setup a FStar environment either with opam or git clone
2. Do "make all"

### Problems
We have issues verifying and "making" the necessary libraries (the Lib. files imported) such that we can produce the ml-files and an executable. As of right now much of the verification fails straight form the import.

## Dune using hacl-star lib
Secondly, we have a dune file to import the hacl-star library from opam to build an executeable in conjuction with the main.ml file. To
build; dune build.
### Install
1. Opam install fstar
2. Opam install hacl-star
3. Inside the hacl-star opam library, do "dune build" (probably
 in ...\.opam\ocaml-variants.4.07.1+mingw64c\lib\hacl-star)
4. Do "dune build"

### Problems
It is difficult write the necessary code to use the Curve25519
methods as the c-counterpart documentation is not one-to-one. It 
has not been written yet.