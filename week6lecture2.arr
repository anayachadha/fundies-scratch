use context dcic2024
#[list: 2, 3, 4, 5, 6]
#[list: 2] first ; [list: 2, 4, 5, 6]

#|
  cases (List) l:
   | empty => ... #the answer for no elements
   | link(f, r) => ... #combine f will be answer for rest
   end
   
- f = first, r = rest
|#


[list: 1, 2, 3].first #1
[list: 1, 2, 3].rest #[list: 2, 3]
[list: 1].rest #[list: ]
is-link([list: 1, 2, 3].rest) #true
is-empty([list: ]) #true
is-empty([list: 3].rest) #true

#building lists with link
check:
  [list: ] is empty
  [list: 1] is link(1, empty)
  [list: 1, 2] is link(1, link(2, empty))
  [list: 1, 2, 3] is link(1, link(2, link(3, empty)))
end

temp-list = link(1, link(2, link(3, empty)))
temp-list.length()

fun my-len(l):
  cases (List) l:
    | empty => 0
    | link(f, r) => 1 + my-len(r)
  end
where:
  my-len([list: 4, 5, 6, 7, 8, 9]) is 6
end

my-len([list: 3, 4]) 

check 'some of my-len examples':
  my-len([list: 1, 2, 3]) is 3
  my-len([list: ]) is 0
  my-len([list: 7, 8, 9]) is 1 + my-len([list: 8, 9])
  my-len([list: 7, 8, 9]) is 1 + my-len([list: 7, 8, 9].rest)
  my-len([list: 9]) is 1 + my-len([list: 9].rest)
end

fun my-sum(l):
  cases (List) l:
    | empty => 0
    | link(f, r) => f + my-sum(r)
  end
where: 
  my-sum([list: 1, 2, 3, 4, 5]) is 15
end

#my-double, and the tempting mistake
[list: 3 * 2, [list: 10 , 4]] #[list: 6, [list: 10, 4]]
link(3 * 2, [list: 10, 4]) #[list: 6, 10, 4]

fun my-double(l):
  cases(List) l:
    | empty => empty
    | link(f, r) => link(f * 2, my-double(r))
  end
where: my-double([list: 3, 5, 2]) is [list: 6, 10, 4]
end

check 'some of my-sum examples':
  my-sum([list: 1, 2, 3]) is 6
  my-sum([list: ]) is 0
end

check:
  my-double([list: 3, 5, 2]) is link(6, link(10, link(4, empty)))
  my-double([list: 3, 5, 2]) is-not [list: 3 * 2, my-double([list: 5, 2])]
end