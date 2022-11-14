build:
	dune build

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

play:
	OCAMLRUNPARAM=b dune exec src/main.exe

clean:
	dune clean

zip:
	rm -f Pigeonhole.zip
	zip -r Pigeonhole.zip .
