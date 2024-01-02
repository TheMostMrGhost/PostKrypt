(* Definition of types used in graphics rendering *)
type r
type r2
type point
type vec
type pic
type picture


val ( +| ) : r2 -> r2 -> r2
val ( *| ) : r -> r2 -> r2

val string_of_pic : pic -> string
val string_of_picture : picture -> string

(* Line between two points. *)
val line : point -> point -> picture
(* Rectangle of a given width and height, centered at (0, 0). *)
val rectangle : r -> r -> picture
(* Sum of two pictures. *)
val (+++) : picture -> picture -> picture

(* Sample picture, baloon-like. *)
val baloon : picture


type intLine = (int * int) * (int * int)
type intRendering = intLine list

(* Magnifying factor, picture to render *)
val renderScaled : int -> picture -> intRendering

