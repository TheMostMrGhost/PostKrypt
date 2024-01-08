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
