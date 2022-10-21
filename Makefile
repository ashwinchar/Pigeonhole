build:
	dune build

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

play:
	OCAMLRUNPARAM=b dune exec src/grid.exe

clean:
	dune clean