use context dcic2024
#|
   the two operations:
  1. transform column - 
   - your function takes one vlaue
   - you get back same columns, new value in one column
   
  2. build column
   - your function takes one whole row
   - you get back one extra column 
|#

sales = table: item :: String, price :: Number, qty :: Number
  row: 'tea', 2.50, 4
  row: 'coffee', 3.00, 2
  row: 'cake', 4.25, 3
end

#transform column
#add VAT to every price
fun add-vat(p :: Number) -> Number:
  doc: 'returns the price with 20 percent VAT added'
  p * 1.2
where:
  add-vat(10) is 12
  add-vat(0) is 0
end

with-vat = transform-column(sales, 'price', add-vat)
sales.get-column('price')
with-vat.get-column('price')

#using lamda
transform-column(sales, 'price', lam(p): p * 1.2 end)

#build column
fun line-total(r :: Row) -> Number:
  doc: 'returns price times quantity for one order line'
  r['price'] * r['qty']
where:
  line-total(sales.row-n(0)) is 10
  line-total(sales.row-n(2)) is 12.75
end

with-total = build-column(sales, 'total', line-total)
sales
with-total.get-column('total')

#chain them: operations compose, because each returns a table
#add VAT, then total the VAT - inclusive proces

billed = build-column(transform-column(sales, 'price', add-vat), 'total', line-total)
billed

#SYNTAX
#build column(table, 'new column', line total)
#transform-column(table, 'exisiting column', add-vat)