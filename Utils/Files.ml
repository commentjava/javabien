let rec sort = function
  | [] -> []
  | x :: l -> insert x (sort l)

and insert elem = function
  | [] -> [elem]
  | x :: l ->
      if elem < x then elem :: x :: l else x :: insert elem l
;;

let dir_contents dir =
  (* Return a list of files in dir and it subdirectories *)
  let rec loop result = function
    | f::fs when Sys.is_directory f ->
          Sys.readdir f
          |> Array.to_list
          |> List.map (Filename.concat f)
          |> List.append fs
          |> sort
          |> loop result
    | f::fs -> loop (result @ [f]) fs
    | []    -> result
  in
    loop [] [dir]

let dir_is_empty dir =
  (* Return true if dir is empty except . and .. *)
  Array.length (Sys.readdir dir) = 0

