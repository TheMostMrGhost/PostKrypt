module Picture : sig
    type r 
    type r2
    type point
    type vec
    type pic = 
        | Empty
        | Vector of vec 
        | Point of point
    type picture

    val ( +| ) : point -> point -> point
    val ( *| ) : r -> point -> point
    val string_of_pic : pic -> string
    val string_of_picture : picture -> string
    val string_of_point : point -> string
    val line : point -> point -> picture
    val rectangle : r -> r -> picture
    val (+++) : picture -> picture -> picture
    val scale : r -> picture -> picture
    val make_point: float -> float -> point
    val make_vec: point -> point -> vec
    val make_r : float -> r
    val r_of_int : int -> r
    val empty : picture
    val add_to_picture : pic -> picture -> picture
    val point_to_pic : point -> pic
    val vec_to_pic : vec -> pic
    val picture_to_postscript : int -> picture -> string
end

module Transform : sig
    type transform

    (* Supported transformations *)
    val id : transform
    val sum : transform -> transform -> transform
    val translate : Picture.vec -> transform
    val rotate : Picture.r -> transform
    (* Val for a full circle rotation, in degrees. *)
    val full_circle : Picture.r

    (* Application of transformations *)
    val trpoint : transform -> Picture.point -> Picture.point
    val trvec : transform -> Picture.vec -> Picture.vec
    val transform : transform -> Picture.picture -> Picture.picture
end

module Graph : sig
  val draw_point : float -> float -> unit
  val draw_vector : (float * float) * (float * float) -> unit
  val picture_to_graph : int -> Picture.picture -> unit
end
