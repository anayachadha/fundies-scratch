use context dcic2024
#|
   overlay(circle(30, 'solid', 'red'), rectangle(140, 120, 'solid', 'green'))

c = circle(30, 'solid', 'red')
r = rectangle(140, 120, 'solid', 'green')
frame(overlay(c, r))

frame(above(rectangle(80, 20, 'solid', 'green'), rectangle(80, 20, 'solid', 'purple')))

side = 45
colour = 'pink'
pink-sq = rectangle(side, side, 'solid', colour)

fun three-stripped-flag(top-color, middle-color, bottom-color):
  frame(
      above(rectangle(100, 30, 'solid', top-color),
        above(rectangle(100, 30, 'solid', middle-color),
          rectangle(100, 30, 'solid', bottom-color))))
end
three-stripped-flag('red', 'orange', 'yellow')

cake1 = frame(above(rectangle(80, 40, 'solid', 'pink'), above(rectangle(80, 40, 'solid', 'purple'), rectangle(80, 40, 'solid', 'blue'))))

cake2 = frame(above(rectangle(80, 40, 'solid', 'yellow'), above(rectangle(80, 40, 'solid', 'green'), rectangle(80, 40, 'solid', 'blue'))))

fun three-layer-cake(top-color :: String, middle-color :: String, bottom-color :: String) -> Image:
  doc: 'three layered cake'
  frame(above(rectangle(80, 40, 'solid', top-color),
      above(rectangle(80, 40, 'solid', middle-color),
        rectangle(80, 40, 'solid', bottom-color))))
where: 
  three-layer-cake('pink', 'purple', 'blue') is cake1
  three-layer-cake('yellow', 'green', 'blue') is cake2
end

calculate-tax = 
  table: price
    row: 200
    row: 500
    row: 870
  end

fun sales-tax(r :: Row) -> Number:
  doc: 'calculates the sales tax'
  r['price'] * 12.5
  
where:
  sales-tax(calculate-tax.row-n(0)) is 200 * 12.5
  sales-tax(calculate-tax.row-n(2)) is 870 * 12.5
end

build-column(calculate-tax, 'tax', sales-tax) 
|#
import math as m
import statistics as s
import lists as l
include csv
url = 'https://raw.githubusercontent.com/neu-pdi/cs2000-public-resources/refs/heads/main/static/support/10-voters.csv'

voter-data = 
  load-table: VoterID,FirstName,LastName,DOB,Party,Address,City,State,Zip,Phone,Email,LastVoted 
    source: csv-table-url(url, default-options)
end

fun blank-entry(s :: String) -> String:
  doc: 'fixing the empty entry mistake'
  if s == "":
    'none'
  else if s == " ":
    'none'
  else:
    s
  end
where:
  blank-entry("") is 'none'
  blank-entry(" ") is 'none'
  blank-entry("Democrat") is "Democrat"
end

transform-column(voter-data, 'Party', blank-entry)

fun normalise-phone(s :: String) -> String:
  doc: 'transform all phone number to the form NNNNNNNNNN'
  no-dashes = string-replace(s, '-', '')
  no-dots = string-replace(no-dashes, '.', '')
  no-spaces = string-replace(no-dots, ' ', '')
  no-brackets = string-replace(no-spaces, '(', '')
  string-replace(no-brackets, ')', '')
where: 
  normalise-phone('(555) 123-4567') is '5551234567'
  normalise-phone('555.987.6543') is '5559876543'
end

transform-column(voter-data, 'Phone', normalise-phone)

fun normalise-dob(s :: String) -> String:
  doc: 'normalise all dob to yyyy-mm-dd'
  string-replace(s, '/', '-')
where:
  normalise-dob('1978/07/08') is '1978-07-08'
end

transform-column(voter-data, 'DOB', normalise-dob)

cafe-data =
  table: day :: String, drinks-sold :: Number
    row: "Mon", 45
    row: "Tue", 30
    row: "Wed", 55
    row: "Thu", 40
    row: "Fri", 60
  end
cafe-data

cafe = cafe-data.get-column('day')
select-columns(cafe-data, [list: 'day'])
m.min(cafe)

quiz-scores =
  table: student :: String, quiz1 :: Number, quiz2 :: Number, quiz3 :: Number
    row: "Alice", 85, 92, 78
    row: "Bob", 90, 88, 95
    row: "Charlie", 78, 85, 82
    row: "Diana", 95, 90, 88
  end

a = quiz-scores.get-column('quiz1')
b = quiz-scores.get-column('quiz2')
c = quiz-scores.get-column('quiz3')

s.mean(a)
s.mean(b)
s.mean(c)

discount-codes = [list: "NEWYEAR", "student", "NONE", "student", "VIP", "none"]
unique = l.distinct(discount-codes)

l.map(string-to-upper, unique)

survey = [list: "yes", "NO", "maybe", "Yes", "no", "Maybe"]

unique-codes = l.distinct(survey)
unique-codes 
lower-case = l.map(string-to-lower, unique-codes)
lower-case
new-distinct = l.distinct(lower-case)
new-distinct
x = l.filter(lam(s) : s <> 'maybe' end, new-distinct)
x


products =
  table: name :: String, price :: Number
    row: "laptop", 999.99
    row: "mouse", 25.50
    row: "keyboard", 75.00
    row: "monitor", 299.99
  end

extract-column = products.get-column('price')
filter-list = l.filter(lam(e) : e < 100 end, extract-column)
discount = l.map(lam(r) : r - (10/100) end, filter-list) 

fruits = [list: "apple", "banana", "cherry", "date", "elderberry"]
l.get(fruits, 2)
l.filter(lam(r) : string-length(r) > 5 end, fruits)


fun product(l :: List<Number>) -> Number block:
  var total = 1
  for each(item from l):
    total := total * item
  end
  total
where:
  product([list: 2, 3, 4]) is 24
  product([list: 7, 3]) is 21
end

fun my-length(l :: List<Any>) -> Number block:
  doc: 'returns number of elements in a list'
  var lengths = 0
  for each(item from l):
    lengths := lengths + 1
  end
  lengths
where: 
  my-length([list: 'anaya', 'ekam']) is 2
  my-length([list: 1, 'hello', true]) is 3
  my-length([list: ]) is 0
end

fun any-negative(l :: List<Number>) -> Boolean block:
  doc: 'returns true if at least one negative number, otherwise false'
  var negative = false
  for each(item from l):
    if item < 0:
      negative := true
    else:
      nothing
    end
  end
  negative
where:
  any-negative([list: 1, 2, 5, -9, 8]) is true
  any-negative([list: -3, -4, 0, 5]) is true
  any-negative([list: 1, 2, 5, 9, 8]) is false
  any-negative([list: ]) is false
end

 
data BookRecord : book(title :: String, author :: String, pages :: Number) end

fun my-sum(l :: List) -> Number:
  cases (List) l:
    | empty => 0
    | link(f, r) => f + my-sum(r)
  end
where:
  my-sum([list: ]) is 0
  my-sum([list: 7, 8, 9]) is 7 + 8 + 9
  my-sum([list: 7, 8]) is 7 + 8
  my-sum([list: 9]) is 9 + 0
end

feed = table: author, caption
  row: "amira", "Heatwave Warning Today"
  row: "ben", "NEW bike lanes OPEN"
  row: "chen", "tree planting at 10am"
end

(0.1 + 0.2) == 0.3
  