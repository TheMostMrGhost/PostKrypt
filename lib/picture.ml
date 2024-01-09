module Picture = struct
    type r = float
    type r2 = r * r
    type point = r2
    type vec = r2 * r2
    type pic = 
        | Empty
        | Vector of vec 
        | Point of point
    type picture = pic list

    let ( +| ) (x1, y1) (x2, y2) = (x1 +. x2, y1 +. y2)
    let ( -| ) (x1, y1) (x2, y2) = (x1 -. x2, y1 -. y2)
    let ( *| ) scale (x, y) = (scale *. x, scale *. y)

    let string_of_pic x = match x with
        | Empty -> ""
        | Vector ((x1, y1), (x2, y2)) -> Printf.sprintf "Vector ((%f, %f), (%f, %f))" x1 y1 x2 y2
        | Point (x, y) -> Printf.sprintf "Point (%f, %f)" x y

    let string_of_point x = match x with
        | (x, y) -> Printf.sprintf "(%f, %f)" x y

    let string_of_picture x = match x with
        | [] -> "[]"
        | hd :: tl -> "[" ^ (string_of_pic hd) ^ (List.fold_left (fun acc x -> acc ^ "; " ^ (string_of_pic x)) "" tl) ^ "]"

    let line (x1, y1) (x2, y2) = [Vector ((x1, y1), (x2, y2))]

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

    let (+++) pic1 pic2 = pic1 @ pic2

    let scale factor pic = List.map (function
        | Empty -> Empty
        | Vector ((x1, y1), (x2, y2)) -> Vector ((factor *| (x1, y1)), (factor *| (x2, y2)))
        | Point (x, y) -> Point (factor *| (x, y))
    ) pic

    let make_point (x : float) (y : float) : point = (x, y)
    let make_vec (start_x, start_y) (end_x, end_y) = ((start_x, start_y), (end_x, end_y))
    let make_r (x : float) : r = x
    let r_of_int (x : int) : r = float_of_int x

    let point_to_pic pt = Point pt
    let vec_to_pic vec = Vector vec

    let empty = []

    let add_to_picture pic picture = pic :: picture

    let vector_to_postscript (x1, y1) (x2, y2) =
        Printf.sprintf "%f %f moveto %f %f lineto\n" x1 y1 x2 y2

    let picture_to_postscript (scale_factor : int) picture =
        let scaled_picture = scale (r_of_int scale_factor) picture in
        let rec helper_pic pic =
            match pic with
            | [] -> ""
            | hd :: tl -> 
                let command_string = match hd with
                    | Empty -> ""
                    | Vector ((x1, y1), (x2, y2)) -> vector_to_postscript (x1, y1) (x2, y2)
                    | Point (x, y) -> vector_to_postscript (x, y) (x, y)
                in
                command_string ^ helper_pic tl
        in
        Printf.sprintf "%%!PS\n300 400 translate\n%sstroke showpage\n%%EOF" (helper_pic scaled_picture)

end

module Transform = struct
    let fullCircle = 360.
    open Picture

    type simple_transform = 
        | Translation of vec
        | Rotation of r

    type transform = simple_transform list

    let id : transform = []

    let sum (t1 : transform) (t2 : transform) : transform =
        t1 @ t2

    let translate (v : vec) : transform =
        (Translation v) :: id

    let rotate angle : transform =
        (Rotation angle) :: id

    let rotate_apply p angle =
        let (x, y) = p in
        (x *. cos (angle /. fullCircle *. 2. *. Float.pi) -. y *. sin (angle /.
            fullCircle *. 2. *. Float.pi), x *. sin (angle /. fullCircle *. 2.
                *. Float.pi) +. y *. cos (angle /. fullCircle *. 2. *.
                Float.pi))

    let translate_apply p (v : vec) : point =
        match v with
        | (x, y) -> y -| x +| p

    let apply_simple_transform (t : simple_transform) (p : point) : point =
        match t with
        | Translation v -> translate_apply p v
        | Rotation angle -> rotate_apply p angle 

    let trpoint (t : transform) (p : point) : point =
        let rec helper_tr (t : transform) (p : point) : point =
            match t with
            | [] -> p
            | hd :: tl -> helper_tr tl (apply_simple_transform hd p)
        in
        helper_tr t p

    let trvec (t : transform) (v : vec) : vec =
        let rec helper_tr (t : transform) (v : vec) : vec =
            match t with
            | [] -> v
            | hd :: tl ->
                let ((start_x, start_y), (end_x, end_y)) = v in
                let transformed_start = apply_simple_transform hd (start_x, start_y) in
                let transformed_end = apply_simple_transform hd (end_x, end_y) in
                helper_tr tl (transformed_start, transformed_end)
        in
        helper_tr t v

    let transform (t : transform) (pic : picture) : picture =
        List.map (function
            | Empty -> Empty
            | Vector v -> Vector (trvec t v)
            | Point p -> Point (trpoint t p)
        ) pic
end
