# About the implementation
The code was developed using Julia 0.6.2 (newer versions may not work)

Julia 1.0 was'nt released at the time we started writing the code. That's why we are bound to an older version. Maybe later we'll migrate it to Julia 1.0

All the needed packages are auto-installed from the main.jl

To execute the analysis all you need is to call include("main.jl")

On the first line of main.jl there's input = "input/fib.nl"

This is where you define the code to be analysed.

All the outputs are stored on   ../outputs/ folder

# How to execute the code

First you need to download Julia 0.6.2

Here you can get the 64bits [Windows version](https://julialang-s3.julialang.org/bin/winnt/x64/0.6/julia-0.6.2-win64.exe)

And here you can get the 64bits [Linux version](https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.2-linux-x86_64.tar.gz)

If the links above don't work, you can find the versions for download [here](https://julialang.org/downloads/oldreleases.html)

After that you need to open the Julia REPL, which is located under .../julia/bin/julia (tested on the Linux version)

From the Julia terminal, all you need to do is to call include(".../src/main.jl")

On the very first time you execute this, the code will start downloading the needed packages from Github, it may take several minutes depending on your internet.

Even after you have a full installation of the packages, the first executions of the include may take something around 30 seconds to be completed due to the loading time of the already installed packages. But it's only on the first time you call the command for that specific workspace. On the second time ahead the Julia interpreter notices the package is already loaded and skips the loading phase.

The needed packages are listed on the very begining of the main.jl code
# Specifications resume

The implementation was done using a predictive tabular analyser
The LL(1) table may be found here [tabela_LL1.csv](https://github.com/NaelsonDouglas/namelesscompiler/blob/master/especificações/tabela_LL1.csv)

The more detailed specifications about the grammar may be found, in brazilin portuguese, [here](https://github.com/NaelsonDouglas/namelesscompiler/blob/master/especificações/2018.1%20Especificações%20compiladores.pdf)

The grammar productions specifications may be found [here](https://github.com/NaelsonDouglas/namelesscompiler/blob/master/especificações/gramática.txt)