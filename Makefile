build:
	dune build

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

play:
	OCAMLRUNPARAM=b dune exec graphics/ray.exe

clean:
	dune clean

zip:
	rm -f Pigeonhole.zip
	zip -r Pigeonhole.zip .
