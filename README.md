# About the implementation
The code was developed using Julia 0.6.2 (newer versions may not work)
All the needed packages are auto-installed

To execute the analysis all you need is to call include("main.jl")

On the first line of main.jl there's input = "input/fib.nl"
This is where you define the code to be analysed.

All the outputs are store on the ../outputs/ folder


# Specifications resume


The implementation was done using a predictive tabular analyser
The LL(1) table may be found here [tabela_LL1.csv](https://github.com/NaelsonDouglas/namelesscompiler/blob/master/especificações/tabela_LL1.csv)

The more detailed specifications about the grammar may be found, in brazilin portuguese, [here](https://github.com/NaelsonDouglas/namelesscompiler/blob/master/especificações/2018.1%20Especificações%20compiladores.pdf)

The grammar productions specifications may be found [here](https://github.com/NaelsonDouglas/namelesscompiler/blob/master/especificações/gramática.txt)