let readPic () =
  let rec read_lines acc =
    try
      let line = input_line stdin in
      if line = "end" then acc
      else read_lines (acc @ String.split_on_char ' ' line)
    with End_of_file -> acc
  in
  read_lines []
