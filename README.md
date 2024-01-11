# About PostKrypt

PostKrypt is a project dedicated to developing a language for image
manipulation. Inspired by and compatible with PostScript, PostKrypt is an
assignment for the "Języki i narzędzia programowania" course at MIM UW for the
academic year 2023/2024.

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
## Basic usage
The program accepts a set of operations and numbers and based on them creates a drawing in the PostScript format.
The output is delivered to `stdout`. The output should then be displayed using
a PostScript reader, like [ghostscript](https://www.ghostscript.com/).
Assuming that you have a file `input.in`, containing valid set of commands, you can use it as
```bash
cat input.in | ./_build/default/bin/main.exe > my_out.out 
gs my_out.out
```
where an example `input.in` file might look like this
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
./_build/default/bin/main.exe -f input.in > my_out.out 
```


Additional flag `-g` allows for displaying the picture direcly.

### Commands
