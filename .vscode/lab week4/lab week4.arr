use context dcic2024
#EXERCISE 1 - LONG FLIGHTS
include csv
include data-source
flights = load-table:
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

  source: csv-table-file("flights.csv", default-options)

    # converting the numeric columns from strings to numbers
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

fun is_long_flight(r :: Row) -> Boolean:
  doc: "returns true if the flightss distance is at least 1500 miles."
  r["distance"] >= 1500
where:
  is_long_flight((table: distance row: 1500 end).row-n(0)) is true
  is_long_flight((table: distance row: 2475 end).row-n(0)) is true
  is_long_flight((table: distance row: 200 end).row-n(0)) is false
end

#keeping only the long flights
long-flights = filter-with(flights, is_long_flight)
long-flights

#largest air time first
long-flights-sorted = order-by(long-flights, "air_time", false)
long-flights-sorted

#first row is flight with the longest air time
ex1-row = long-flights-sorted.row-n(0)
ex1-row
ex1-carrier = ex1-row["carrier"]
ex1-carrier
ex1-origin = ex1-row["origin"]
ex1-origin
ex1-dest = ex1-row["dest"]
ex1-dest

#EXERCISE 2 - DELAYED MORNING FLIGHTS
