pdf:
	latexmk -pdf -shell-escape djangosimples.tex

pvc:
	latexmk -pdf -shell-escape -pvc djangosimples.tex

pdf43:
	latexmk -pdf -shell-escape djangosimples43.tex

pvc43:
	latexmk -pdf -shell-escape -pvc djangosimples43.tex

clear:
	latexmk -c
	rm *.nav *.snm *.vrb
