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
    let ( *| ) scale (x, y) = (scale *. x, scale *. y)

    let string_of_pic x = match x with
        | Empty -> ""
        | Vector ((x1, y1), (x2, y2)) -> Printf.sprintf "Vector ((%f, %f), (%f, %f))" x1 y1 x2 y2
        | Point (x, y) -> Printf.sprintf "Point (%f, %f)" x y

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
end

module Transform = struct
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

end
