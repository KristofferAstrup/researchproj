FSTAR_FILES=$(wildcard *.fst)

# A place to put all the emitted .ml files
OUTPUT_DIRECTORY=_output

################################################################################
FSTAR=fstar.exe --cache_checked_modules --odir $(OUTPUT_DIRECTORY)
#ML_FILES=$(addprefix $(OUTPUT_DIRECTORY)/,$(addsuffix .ml,$(subst .,_, $(subst .fst,,$(FSTAR_FILES)))))

PROGRAM=myprogram
OCAML_EXE=$(PROGRAM).ocaml.exe

all: verify-all

# a.fst.checked is the binary, checked version of a.fst
%.checked: %
	$(FSTAR) $*
	touch $@

# The _tags file is a directive to ocamlbuild
# The extracted ML files are precious, because you may want to examine them,
#     e.g., to see how type signatures were transformed from F*
.PRECIOUS: _tags $(ML_FILES) $(addsuffix .checked,$(FSTAR_FILES)) $(OUTPUT_DIRECTORY)/out.krml

_tags:
	echo "<ml>: traverse" > $@
	echo "<$(OUTPUT_DIRECTORY)>: traverse" >> $@
	echo "<$(OUTPUT_DIRECTORY)/c>: -traverse" >> $@

# To extract an A.ml ML file from an A.fst, we just reload its A.fst.checked file
# and then with the --codegen OCaml option, emit an A.ml
# Note, by default F* will extract all files in the dependency graph
# With the --extract_module, we instruct it to just extract A.ml
$(OUTPUT_DIRECTORY)/%.ml:
	$(FSTAR) $(subst .checked,,$<) --codegen OCaml

#$(OCAML_EXE): _tags $(ML_FILES)
#    OCAMLPATH="$(FSTAR_HOME)/bin" ocamlbuild -I $(OUTPUT_DIRECTORY) -use-ocamlfind -pkg fstarlib
    

#test.ocaml: $(OCAML_EXE)
#    ./$< hello

clean:
	rm -rf _build $(OUTPUT_DIRECTORY) *~ *.checked $(OCAML_EXE) $(KREMLIN_EXE) .depend

.depend:
	$(FSTAR) --dep full $(FSTAR_FILES) --extract '* -FStar -Prims' > .depend

depend: .depend

include .depend

# The default target is to verify all files, without extracting anything
# It needs to be here, because it reads the variable ALL_FST_FILES in .depend
verify-all: $(addsuffix .checked, $(ALL_FST_FILES))

extract-all: $(ALL_ML_FILES)
