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
    type intLine = (int * int) * (int * int)
    type intRendering = intLine list

    let ( +| ) (x1, y1) (x2, y2) = (x1 +. x2, y1 +. y2)
    let ( -| ) (x1, y1) (x2, y2) = (x1 -. x2, y1 -. y2)
    let ( *| ) scale (x, y) = (scale *. x, scale *. y)

    let string_of_pic x = match x with
        | Empty -> ""
        | Vector ((x1, y1), (x2, y2)) -> Printf.sprintf "%f %f moveto %f %f lineto\n" x1 y1 x2 y2
        | Point (x, y) -> Printf.sprintf "%f %f moveto\n" x y

    let concat_strings x =
        List.fold_left (fun acc x -> acc ^ x) "" x

    let string_of_picture x = 
        let res_str = concat_strings (List.map string_of_pic x) in
        Printf.sprintf "%%!PS\n300 400 translate\n%sstroke showpage\n%%EOF" res_str

    let line (x1, y1) (x2, y2) = [Vector ((x1, y1), (x2, y2))]

    let rectangle width height = 
        let p1 = (0., 0.) in
        let p2 = (width, 0.) in
        let p3 = (width, height) in
        let p4 = (0., height) in
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

    let pic_of_point pt = Point pt

    let pic_of_vec vec = Vector vec

    let empty = []

    let add_to_picture pic picture = pic :: picture

    let picture_to_postscript (scale_factor : int) picture =
        let scaled_picture = scale (r_of_int scale_factor) picture in
            string_of_picture scaled_picture

    let baloon = rectangle 100. 100. +++ line (-100., -100.) (0., 0.)

    (* Rendering on grid instead of floats. *)
    let renderScaled scale pict =
        let scale = r_of_int scale in
        List.fold_right (fun pic acc -> 
            match pic with
            | Empty -> acc
            | Vector ((x1, y1), (x2, y2)) -> 
                let scaled_line = ((int_of_float (scale *. x1), int_of_float (scale *. y1)), 
                    (int_of_float (scale *. x2), int_of_float (scale *. y2))) in
                scaled_line :: acc
            | Point (x, y) -> 
                let scaled_point = ((int_of_float (scale *. x), int_of_float (scale *. y)), 
                    (int_of_float (scale *. x), int_of_float (scale *. y))) in
                scaled_point :: acc
        ) pict []
end

module Transform = struct
    let full_circle = 360.
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
        (x *. cos (angle /. full_circle *. 2. *. Float.pi) -. y *. sin (angle /.
            full_circle *. 2. *. Float.pi), x *. sin (angle /. full_circle *. 2.
                *. Float.pi) +. y *. cos (angle /. full_circle *. 2. *.
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

open Graphics

module Graph = struct
    let ref_x = 600
    let ref_y = 500

    let draw_point (x : float) (y : float) : unit =
        let ix = int_of_float x in
        let iy = int_of_float y in
        moveto (ix + ref_x) (iy + ref_y);
        lineto (ix + ref_x) (iy + ref_y)

    let draw_vector ((x1, y1), (x2, y2)) : unit =
        moveto (int_of_float x1 + ref_x) (int_of_float y1 + ref_y);
        lineto (int_of_float x2 + ref_x) (int_of_float y2 + ref_y)

    let picture_to_graph (scale_factor : int) picture =
        let scaled_picture = Picture.scale (Picture.r_of_int scale_factor) picture in
        let rec helper_pic pic =
            match pic with
            | [] -> ()
            | hd :: tl -> 
                (match hd with
                    | Picture.Empty -> ()
                    | Picture.Vector ((x1, y1), (x2, y2)) -> draw_vector ((x1, y1), (x2, y2))
                    | Picture.Point (x, y) -> draw_point x y);
                helper_pic tl
        in
        helper_pic scaled_picture
end
