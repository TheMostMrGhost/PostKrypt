open Arg

let filename = ref None
let scale = ref 1
let display = ref false

let speclist = [
  ("-n", Set_int scale, " Set scale factor (integer)");
  ("-d", Set display, " Display the image (boolean)");
  ("-f", String (fun f -> filename := Some f), " Filename to read from")
]

let usage_msg = "Usage: graf [-n scale] [-d] [-f filename]\n"

let read_input () =
  match !filename with
  | Some file -> 
      let ic = open_in file in
      let rec read_lines acc =
        try
          let line = input_line ic in
          read_lines (acc ^ line ^ "\n")
        with End_of_file -> close_in ic; acc
      in
      read_lines "", !scale
  | None -> 
      let rec read_stdin acc =
        try
          let line = read_line () in
          read_stdin (acc ^ line ^ "\n")
        with End_of_file -> acc
      in
      read_stdin "", !scale
