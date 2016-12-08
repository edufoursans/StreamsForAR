let rec char_list_of_word (w:word) = match w with
  |[]->[]
  |x::r->let lprime = char_list_of_word r in
         match x with
         |A->'a'::lprime
         |B->'b'::lprime
         |C->'c'::lprime
                    
let string_of_word (w:word) = String.concat "" (List.map (String.make 1) (char_list_of_word w))

                                      
    
(* Creating an actual stream from a stringtree. *)
let rec stream_of_tree_aux (t: stringtree) (position:word) (arg:word) =
  match t with
  |Nil->Endofstream
  |_->
    let pref = prefix arg position in
    match (prefix position arg)||pref with
    |false->Endofstream
    |true->
      let (tmoved,newpos) = match pref with
        |false->(move t (diff position arg),arg)
        |true->(t,position)
      in
      let (next,tprime) = find_next tmoved in
      match next with
      |None->Endofstream
      |Some(word)->
        let f nextarg = stream_of_tree_aux tprime newpos nextarg in
        Cons(word,f)


let stream_of_tree (t:stringtree) = stream_of_tree_aux t []


let rec stream_of_pipetree (t:stringtree pipetree) = match t with
  |AND(g,d)->and_combine (stream_of_pipetree g) (stream_of_pipetree d)
  |OR(g,d)->or_combine (stream_of_pipetree g) (stream_of_pipetree d)
  |Leaf(l)->stream_of_tree l

(* compute the list of words in tree t *)
let rec list_of_tree_aux (t:stringtree) (l:word list) = match t with
  |Nil->l
  |Node(w,a,b,c)->
    let l1 = list_of_tree_aux a l in
    let l2 = list_of_tree_aux b l1 in
    let l3 = list_of_tree_aux c l2 in
    match w with
    |[]->l3
    |_->w::l3
             
let list_of_tree (t:stringtree) = list_of_tree_aux t []                           
