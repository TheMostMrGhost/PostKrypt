type r = float
type r2 = r * r
type point = r2
type vec = r2 * r2
(* TODO should it be this way really? *)
type pic = Vector of vec | Point of point
type picture = pic list

let ( +| ) (x1, y1) (x2, y2) = (x1 +. x2, y1 +. y2)
let ( *| ) scale (x, y) = (scale *. x, scale *. y)

(* TODO this is just a proof of concept, confront it with the requirements.*)
let string_of_pic x = match x with
  | Vector ((x1, y1), (x2, y2)) -> Printf.sprintf "Vector ((%f, %f), (%f, %f))" x1 y1 x2 y2
  | Point (x, y) -> Printf.sprintf "Point (%f, %f)" x y

(* TODO this is just a proof of concept, confront it with the requirements.*)
let string_of_picture x = match x with
    | [] -> "[]"
    | hd :: tl -> "[" ^ (string_of_pic hd) ^ (List.fold_left (fun acc x -> acc ^ "; " ^ (string_of_pic x)) "" tl) ^ "]"

(* Line between two points. *)
(* val line : point -> point -> picture *)
let line (x1, y1) (x2, y2) = [Vector ((x1, y1), (x2, y2))]

(* Rectangle of a given width and height, centered at (0, 0). *)
(* TODO rewrite it using other functions that I declared earlier *)
let rectangle width height = 
  let halfWidth = width /. 2. in
  let halfHeight = height /. 2. in
  let p1 = (-.halfWidth, -.halfHeight) in
  let p2 = (halfWidth, -.halfHeight) in
  let p3 = (halfWidth, halfHeight) in
  let p4 = (-.halfWidth, halfHeight) in
  let l1 = line p1 p2 in
  let l2 = line p2 p3 in
  let l3 = line p3 p4 in
  let l4 = line p4 p1 in
    l1 @ l2 @ l3 @ l4

(* Sum of two pictures. *)
let (+++) pic1 pic2 = pic1 @ pic2

(* Picture scaled by a given factor. *)
let scale factor pic = List.map (function
  | Vector ((x1, y1), (x2, y2)) -> Vector ((factor *| (x1, y1)), (factor *| (x2, y2)))
  | Point (x, y) -> Point (factor *| (x, y))
) pic

(* Sample picture, baloon-like. *)
let baloon = []
  +++ rectangle 1. 1.
  +++ scale 0.5 (rectangle 1. 1.)
  +++ scale 0.25 (rectangle 1. 1.)

let baloon = [] +++ (rectangle 100. 100.) +++ (line (0., 0.) (-100., -100.))

(* TODO this is just a proof of concept, confront it with the requirements.*)

(* TODO this is just a proof of concept, confront it with the requirements.*)
type intLine = (int * int) * (int * int)
type intRendering = intLine list

(* Magnifying factor, picture to render *)
let renderScaled factor pic = List.map (function
  | Vector ((x1, y1), (x2, y2)) -> ((int_of_float (factor *. x1), int_of_float (factor *. y1)), (int_of_float (factor *. x2), int_of_float (factor *. y2)))
  | Point (x, y) -> ((int_of_float (factor *. x), int_of_float (factor *. y)), (int_of_float (factor *. x), int_of_float (factor *. y)))
) pic

