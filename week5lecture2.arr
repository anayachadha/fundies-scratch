use context starter2024
import math as m
import statistics as s

#|
  functions we'll use today: 
   1. filter-with
   2. transform-column
   3. t.row-n
   4. t.length
   5. linked -list
   
   - list is always in square bracets 
|#

cafe-data =
  table: day, drinks-sold
    row: 'mon', 45
    row: 'tue', 30
    row: 'wed', 55
    row: 'thu', 40
    row: 'fri', 60
  end

sales = cafe-data.get-column('drinks-sold')
sales

#some basic stats
m.max(sales) #maximum value in math
s.mean(sales) #mean in statistics
s.median(sales) #median in statistics
m.sum(sales) #sum of all values in math

discount-codes = [list: 'NEWYEAR', 'student', 'NONE', 'student', 'VIP', 'none']
discount-codes

unique-codes = distinct(discount-codes) #gives only unique values, doesnt repeat any
unique-codes

fun is-real-code(code :: String) -> Boolean:
  not(string-to-lower(code) == 'none')
end

real-codes = filter(is-real-code, unique-codes)
real-codes
first-code = real-codes.get(0)
first-code
lower-codes = map(string-to-lower, real-codes)
lower-codes

#distinct keeps the last copy of the repeated value, not the first 
distinct(filter(is-real-code, map(string-to-lower, discount-codes)))

#to sort a list in ascending order
sales.sort()

#to sort a list in descending order
sales.sort().reverse()

#variables that can change
var total = 1
total := total + 10 #:= changes value in a variable that already exists, only works when var is written
total

fun my-sum(num-list :: List) -> Number block:
  doc: 'a decent doc string here...'
  var running = 0
  for each(n from num-list):
    running := running + n
  end
  running
where: 
  my-sum([list: 0, 1, 2, 3]) is 6
  my-sum([list: ]) is 0
end

my-sum(sales)

#produce a new list
fun add-two(numbers :: List<Number>) -> List<Number> block:
  doc: 'adds two to each number if a list'
  var added-two = [list: ]
  for each(n from numbers):
    added-two := added-two.append([list: n + 2])
  end
  added-two
where:
  add-two([list: 1, 2, 3]) is [list: 3, 4, 5]
end

fun vat-amount(prices :: List<Numbers>) -> List<Numbers> block:
  doc: 'returns the 20% VAT on each price in the list'
  var vats = [list: ]
  for each (p from prices):
    vats := vats.append([list: p * 0.2])
  end
  vats
  where vat-amounts([list: 10, 50, 100]) is [list: 2, 10, 20]
end

fun with-vat(prices :: List<Numbers>) -> List<Numbers> block:
  doc: 'returns each price in a list with 10% VAT added
  var final-prices = [list:]
  for each(p from prices):
    final-prices := final-prices.append([list: p * (p * 0.2)])
  end
  final-prices
where:
  with-vat([list: 10, 50, 100]) is [list: 12, 60, 120]
  with-vat([list: ]) is [list: ]
end
with-vat(sales)


#with lambda
map(lam(p): p * (p * 0.2) end, sales)

#fold: the loop template without the var
#fold :: (f :: (Basem Elt -> Base), base :: Base, lst :: List <Elt>) -> 

#|
  three inputs:
   1. a starting value
   2. a rule
   3. a list
|#

fun my-sum-fold(num-list :: List<Number>) -> Number:
  doc: 'a good docstring here...'
  fold(lam(acc, n): acc + n end, 0, num-list)
where: 
  my-sum-fold([list: 0, 1, 2, 3]) is 6
  my-sum-fold([list: ]) is 0
end

#|
   fold(lam(acc, n): acc + n end, 0, [list: 45, 30, 55]) 
   
   answer so far: 0, 45, 75
   nect item: 45, 30, 55
   new answer: 45, 75, 130
|#