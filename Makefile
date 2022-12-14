.PHONY: test check

build:
	dune build

test:
	OCAMLRUNPARAM=b dune exec test/test.exe

play:
	OCAMLRUNPARAM=b dune exec graphics/ray.exe

clean:
	dune clean

zip:
	rm -f Pigeonhole.zip
	zip -r Pigeonhole.zip .

doc:
	dune build @doc

opendoc: doc
	@bash opendoc.sh
