use context dcic2024
include csv
include data-source
#|
  TASKS FOR TODAY
   1. plan a task before coding it
   2. finding and cleaning dirty data
   3. visualisation 


task plan is a to do list you can check off

input = the columns you start from
output = a concrete example of what you want at the end
steps = small enough that each on is a single function or table operation
tools = the operation for each step: filter-with, transform-column
|# 

#load voters data
voter-data = load-table: VoterID, DOB, Party, Address, City, Country, Postcode
  source: csv-table-url('https://raw.githubusercontent.com/NU-London/LCSCI4207-datasets/refs/heads/main/voters.csv', default-options)
end
voter-data

voter-data.row-n(0)['VoterID'] #output is 1

#confirm the party problem 
filter-with(voter-data, lam(r): r['Party'] == 'Labour' end).length() #output is 4

voter-data.row-n(3)['Party'] #output is labour

order-by(count(voter-data, 'Party'), 'count', false)

#reading one value with get-column
fun get-column(r :: Row, colname :: String):
  doc: 'returns the value in row r for the column colname'
  r[colname]
where:
  get-column(voter-data.row-n(3), "Party") is 'Labuor'
  get-column(voter-data.row-n(0), "VoterID") is '1'
end

filter-with(voter-data, lam(r): get-column(r, 'Party') == 'Labour'end).length()
get-column(voter-data.row-n(3), 'Party')

with-year = build-column(voter-data, 'BirthYear', lam(r): string-substring(get-column(r, 'DOB'), 6, 10)end)
with-year

get-column(with-year.row-n(0), 'BirthYear')

#fixing the typo - labuor
fun fix-labour(s :: String) -> String:
  doc: 'corrects the one known misspelling of labour'
  if s == 'Labuor' : 'Labour' #misspelling of labour party
  else if s == '' : 'No Party' #fill in missing values with 'no party'
  else: s
  end
where:
  fix-labour('Labuor') is 'Labour'
    fix-labour('') is 'No Party'
  fix-labour('Green Party') is 'Green Party'
end

#changing value using transform column
fixed = transform-column(voter-data, 'Party', fix-labour)
fixed

#bar chart
freq-bar-chart(fixed, 'Party')