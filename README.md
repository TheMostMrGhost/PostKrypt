# About PostKrypt

PostKrypt is a project dedicated to developing a language for image
manipulation. Inspired by and compatible with PostScript, PostKrypt is an
assignment for the "Języki i narzędzia programowania" course at MIM UW for the
academic year 2023/2024.

# Installation
## Prerequisits
- `ocaml` toolkit, can be found [here](https://opam.ocaml.org/doc/Install.html)
- `dune` build system. [Dune](https://dune.build/)
- local copy of the project

## Setup
1. Navigate to the main folder.
2. Install necessary dependencies via
```bash
opam install graphics
```
3. Build the project
```bash
dune build --profile release
```


## Project structure
Project contains the following modules.

### Picture
Module responisble for geometric basic objects building a picture.
Contains types such as 
- `point` - a point in $\mathbb{R}^2$
- `vec` - a vector between two points, element of $\mathbb{R}^2 \times \mathbb{R}^2$
- `pic` - a variant type representing either an empty picture, a point or a vector
- `picture` - collection of `pic`'s, represents a picture that will be displayed on a canvas


### Transform
Module responsible for various transofrmation of pictures.
Currently supported:
- identity transform
- rotation by a given angle around $(0,0)$. Angle is expressed in degrees.
- translation by a vector
- composition of transformations
- application of transformations to
    - points
    - vectors
    - pictures

## Viewing output
For opening a PostKrypt file you can use a PostScript reader, like
[ghostscript](https://www.ghostscript.com/).
The command for opening example file, like this one
```postscript
newpath      
0 0 moveto   
0 100 lineto 
100 100 lineto 
100 0 lineto 
closepath    

stroke      
showpage   
```
is `gs <file_name>`.

# Usage example
Basic examples (good and bad ones) are in the folder `examples`.

The program accepts a set of operations and numbers and based on them creates a drawing in the PostScript format.
The output is delivered to `stdout`. The output should then be displayed using
a PostScript reader, like [ghostscript](https://www.ghostscript.com/).
Assuming that you have a file `input.in`, containing valid set of commands, you can use it as
```bash
cat examples/good03.in | ./_build/default/bin/graf.exe > my_out.out 
gs my_out.out
```
where an example `examples/good03.in` file might look like this
```postscript
0 0 moveto
0 100 lineto
100 100 lineto
100 0 lineto
closepath
```
<!-- TODO: sample picture-->
You can also type commands directly into the programme.
Instead of piping, you can use `-f <filename>` flag to load the file directly. The above example wouod look like 
```bash
./_build/default/bin/graf.exe -f examples/good03.in > my_out.out 
```
Additional flag `-d` allows for displaying the picture direcly, instead of writing it to a file.
To scale a picture by an integer number use flag `-n <number>`.

## Commands
Below are listed commands accepted by the program (separated by whitespace).
Most of them are operations which require argument. 
Number of arguments is written next to the operation. All arguments are of type `float`.
Arguments are taken from the stack and result is
put back on it (postfix order of operations).
Graphical operations do not add anything to the stack, but modify the resulting picture instead.
If the stack has lesser number of elements than required, the program throws an error.

**IMPORTANT**: Drawing requires setting a current position (it is not set at the beginning). This can be done via `moveto` command.
Drawing without current position set up results in an error, except for `closepath` operation (which does nothing in such case).

- numbers (float)
- arithmetic operators
    - `add`, `[2]`
    - `sub`, `[2]`
    - `mul`, `[2]`
    - `div`, `[2]`
- `moveto`, `[2]`. Starts a new path.
- `lineto`, `[2]`
- `translate`, `[2]`
- `rotate`, `[1]`
- `closepath`, `[0]`. Draws line to the beginning of the current path, adds it
to the picture and creates new, empty path.


