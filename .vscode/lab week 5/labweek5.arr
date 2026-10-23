use context dcic2024
#TASK 1 - TASK PLANNING 
#|
  INPUTS:
   - flights_sample53.csv (53 rows, 17 columns), loaded into a table called flights
   - columns I will work with: carrier, tailnum, air_time, distance, dep_time, sched_dep_time, time_hour, flight, origin, dest, arr_delay
   
  OUTPUTS:
   - a cleaned table with consistent carrier codes, no missing tailnums, no duplicate flights, no impossible air_time/distance values and times in one format
   - a frequency bar chart of carrier from the cleaned table
   - summary statistics (max, mean, sum) from the cleaned table

  STEPS:
   1. load the table and print it to look for problems
   - load-table with csv-table-file, then print the table
   
   2. problem: carrier has extra spaces and lowercase letters (" b6 ", " wn ")
   planned step: trim spaces and convert to uppercase
   - transform-column with a lambda using string-replace functions and string-to-upper
   
   3. problem: tailnum is empty for 5 flights
   planned step: replace "" with "unknown". The original file stays the same, because missing and unknown are not the same thing
   - transform-column with a function like blank-to-unknown
   
   4. problem: air_time 2000/3000 and distance 10000/20000 are impossible (JFK to LAX is only 2475 miles and about 350 minutes)
   planned step: filter those flights out
   - filter-with with a lambda that keeps air_time < 1000 and distance < 5000
   
   5. problem: some flights appear twice (flights 3895, 316 and 4662)
   planned step: after fixing carrier, keep one row per flight number
   the copies can differ (blank tailnum, a wrong arr_delay), so I can't compare whole rows, I compare flight + origin + dest + sched_dep_time
   - order so the best copy comes first, then keep the first of each

   6. problem: dep_time and sched_dep_time are integers like 741 and 1500
   planned step: convert them to "HH:MM" text (e.g. "07:41", "15:00")
   - transform-column with a function using number-to-string and string-substring
   
   
   7. problem: time_hour is inconsistent (a May date, odd minutes)
   planned step: check these rows, and note them in a comment. fix or drop them depending on what the lab asks
   
   8. plot the cleaned data
   - freq-bar-chart(clean-flights, "carrier")
   
   9. summary statistics from the cleaned table
   - get-column("air_time") to make a list, then M.max, S.mean, M.sum
   
   10. run the file, check each table, and comment on the results
|#

#TASK 2 - HANDLE MISSING DATA, CLEAN DATA, AND IDENTIFY DUPLICATES
include csv
include data-source
#load the table, numeric columns are converted with num-sanitizer, time_hour is kept as a string
flights_53 = load-table:
  rownames :: Number,
  dep_time :: Number,
  sched_dep_time :: Number,
  dep_delay :: Number,
  arr_time :: Number,
  sched_arr_time :: Number,
  arr_delay :: Number,
  carrier :: String,
  flight :: Number,
  tailnum :: String,
  origin :: String,
  dest :: String,
  air_time :: Number,
  distance :: Number,
  hour :: Number,
  minute :: Number,
  time_hour :: String

  source: csv-table-file("flights_sample53.csv", default-options)

  sanitize rownames using num-sanitizer
  sanitize dep_time using num-sanitizer
  sanitize sched_dep_time using num-sanitizer
  sanitize dep_delay using num-sanitizer
  sanitize arr_time using num-sanitizer
  sanitize sched_arr_time using num-sanitizer
  sanitize arr_delay using num-sanitizer
  sanitize flight using num-sanitizer
  sanitize air_time using num-sanitizer
  sanitize distance using num-sanitizer
  sanitize hour using num-sanitizer
  sanitize minute using num-sanitizer
end

flights_53
#step 1
tail-fixed = transform-column(flights_53, "tailnum",
  lam(s :: String): if s == "": "UNKNOWN" else: s end end)
tail-fixed

#step 2
dep-fixed = transform-column(tail-fixed, "dep_delay",
  lam(n :: Number): if n < 0: 0 else: n end end)

cleaned = transform-column(dep-fixed, "arr_delay",
  lam(n :: Number): if n < 0: 0 else: n end end)
cleaned

#step 3
#trim spaces at both ends
fun trim(s :: String) -> String:
  doc: "Remove spaces from the given string."
  n = string-length(s)
  if n == 0:
    ""
  else:
    string-replace(s, " ", "")
  end
where:
  trim(" b6 ") is "b6"
  trim("UA") is "UA"
  trim("") is ""
end

#turn a number like 5 into "05" so every part has two digits
fun pad-two(n :: Number) -> String:
  doc: "converts a number to a string with at least two digits"
  if n < 10:
    "0" + num-to-string(n)
  else:
    num-to-string(n)
  end
where:
  pad-two(5) is "05"
  pad-two(17) is "17"
  pad-two(0) is "00"
end

#turn a time like 517 into "05:17"
fun format-time(t :: Number) -> String:
  doc: "converts a time like 517 into HH:MM text, e.g. 517 -> 05:17"
  hours = num-floor(t / 100)
  minutes = num-modulo(t, 100)
  pad-two(hours) + ":" + pad-two(minutes)
where:
  format-time(517) is "05:17"
  format-time(1800) is "18:00"
  format-time(2343) is "23:43"
  format-time(5) is "00:05"
end

#normalise the carrier: trim spaces, then uppercase
fun normalise-carrier(c :: String) -> String:
  doc: "trims extra spaces and converts the carrier to uppercase"
  string-to-upper(trim(c))
where:
  normalise-carrier(" b6 ") is "B6"
  normalise-carrier("UA") is "UA"
  normalise-carrier(" wn ") is "WN"
end

#step 4
with-key = build-column(cleaned, "dedup_key",
  lam(r :: Row) -> String:
    flight-text = num-to-string(r["flight"])
    carrier-text = normalise-carrier(r["carrier"])
    time-text = format-time(r["dep_time"])
    flight-text + "-" + carrier-text + "-" + time-text
  end)
with-key

#step 5
#group puts the rows with the same dedup_key together
grouped = group(with-key, "dedup_key")
grouped

#count tells me how many times each dedup_key appears
key-counts = count(with-key, "dedup_key")
key-counts

#keep only the keys that appear more than once, most repeated first
duplicates = order-by(
  filter-with(key-counts, lam(r :: Row) -> Boolean: r["count"] > 1 end),
  "count", false)
duplicates

#TASK 4 - VISUALISATION AND FOR EACH LOOP
final-flights = transform-column(cleaned, "carrier", normalise-carrier)

final-flights-no-outliers = filter-with(final-flights,
  lam(r :: Row) -> Boolean: (r["air_time"] < 1000) and (r["distance"] < 5000) end)
final-flights-no-outliers

#1. three visualisations
#frequency bar chart of flights by airline
freq-bar-chart(final-flights-no-outliers, "carrier")

#histogram of flight distances (bins of 250 miles)
histogram(final-flights-no-outliers, "distance", 250)

#scatter plot of air_time vs distance
scatter-plot(final-flights-no-outliers, "distance", "air_time")

#2. extract the distance column as a list
distances = final-flights-no-outliers.get-column("distance")
distances

#3. for each loops
fun total-distance(lst :: List<Number>) -> Number block:
  doc: "adds up all the numbers in lst using a for each loop"
  var total = 0
  for each(n from lst):
    total := total + n
  end
  total
where:
  total-distance([list: 100, 200, 300]) is 600
  total-distance([list: 5]) is 5
  total-distance([list: ]) is 0
end

fun average-distance(lst :: List<Number>) -> Number:
  doc: "returns the average of lst, or 0 if the list is empty"
  if lst.length() == 0:
    0
  else:
    total-distance(lst) / lst.length()
  end
where:
  average-distance([list: 100, 200, 300]) is 200
  average-distance([list: 10, 20]) is 15
  average-distance([list: ]) is 0
end

fun max-distance(lst :: List<Number>) -> Number block:
  doc: "returns the largest number in a non-empty list using a for each loop"

  var biggest = lst.first
  for each(n from lst):
    if n > biggest:
      biggest := n
    else:
      biggest := biggest
    end
  end
  biggest
where:
  max-distance([list: 100, 300, 200]) is 300
  max-distance([list: 7]) is 7
  max-distance([list: -4, -9]) is -4
end

total = total-distance(distances)
total

average = average-distance(distances)
average

maximum = max-distance(distances)
maximum
