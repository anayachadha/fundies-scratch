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
#checks if the flight was delayed by at least 30 minutes
fun is_delayed_departure(r :: Row) -> Boolean:
  doc: "returns true if dep_delay is at least 30"
  r["dep_delay"] >= 30
where:
  is_delayed_departure((table: dep_delay row: 30 end).row-n(0)) is true
  is_delayed_departure((table: dep_delay row: 45 end).row-n(0)) is true
  is_delayed_departure((table: dep_delay row: 10 end).row-n(0)) is false
end

#checks if the flight was scheduled to leave before noon
fun is_morning_sched_dep(r :: Row) -> Boolean:
  doc: "returns true if sched_dep_time is before 1200"
  r["sched_dep_time"] < 1200
where:
  is_morning_sched_dep((table: sched_dep_time row: 515 end).row-n(0)) is true
  is_morning_sched_dep((table: sched_dep_time row: 1200 end).row-n(0)) is false
  is_morning_sched_dep((table: sched_dep_time row: 1800 end).row-n(0)) is false
end

#lambda filter for delays of 30 or more
delayed = filter-with(flights, lam(r): r["dep_delay"] >= 30 end)
delayed

delayed-morning = filter-with(delayed, lam(r): r["sched_dep_time"] < 1200 end)
delayed-morning

#keep only flights with distance over 500
delayed-morning-far = filter-with(delayed-morning, lam(r): r["distance"] > 500 end)
delayed-morning-far

#worst delays first
delayed-sorted = order-by(delayed-morning-far, "dep_delay", false)
delayed-sorted

#first row is the worst delayed flight
ex2-row = delayed-sorted.row-n(0)
ex2-row
ex2-flight = ex2-row["flight"]
ex2-flight
ex2-origin = ex2-row["origin"]
ex2-origin
ex2-dep-delay = ex2-row["dep_delay"]
ex2-dep-delay

#EXERCISE 3 - CLEAN DELAYS + COMPUTE EFFECTIVE SPEED
#replace negative dep_delay with 0
clean-dep = transform-column(flights, "dep_delay",
  lam(n :: Number): if n < 0: 0 else: n end end)
clean-dep

#same for arr_delay
clean-flights = transform-column(clean-dep, "arr_delay",
  lam(n :: Number): if n < 0: 0 else: n end end)
clean-flights

#new column for speed in mph, 0 if air_time is not above 0
with-speed = build-column(clean-flights, "effective_speed",
  lam(r):
    if r["air_time"] > 0:
      r["distance"] / (r["air_time"] / 60)
    else:
      0
    end
  end)
with-speed

#fastest first
speed-sorted = order-by(with-speed, "effective_speed", false)
speed-sorted

#first row is the fastest flight
ex3-row = speed-sorted.row-n(0)
ex3-row
ex3-carrier = ex3-row["carrier"]
ex3-carrier
ex3-origin = ex3-row["origin"]
ex3-origin
ex3-dest = ex3-row["dest"]
ex3-dest

#EXERCISE 4 - DISCOUNT LATE ARRIVALS + ON TIME SCORE
#lowers arr_delay by 20% when it is between 0 and 45
fun apply-arrival-discount(t :: Table) -> Table:
  doc: "reduces arr_delay by 20% if 0 <= arr_delay <= 45, otherwise leaves it unchanged"
  transform-column(t, "arr_delay", lam(d :: Number):
    if (d >= 0) and (d <= 45): d * 0.8 else: d end
  end)
where:
  test-table =
    table: arr_delay
      row: -10
      row: 0
      row: 30
      row: 60
    end
  apply-arrival-discount(test-table) is
  table: arr_delay
    row: -10
    row: 0 * 0.8
    row: 30 * 0.8
    row: 60
  end
end

discounted = apply-arrival-discount(flights)
discounted

#new column for the on time score
with-score = build-column(discounted, "on_time_score",
  lam(r):  
    dep = if r["dep_delay"] < 0: 0 else: r["dep_delay"] end
    arr = if r["arr_delay"] < 0: 0 else: r["arr_delay"] end
    score = 100 - (dep - arr) - (r["air_time"] / 30)
    if score < 0: 0 else: score end
  end)
with-score

#order by distance first (smallest first) then by score (largest first)
by-distance = order-by(with-score, "distance", true)
ranked = order-by(by-distance, "on_time_score", false)
ranked

#top two flights
first-row = ranked.row-n(0)
second-row = ranked.row-n(1)

first-row
first-carrier = first-row["carrier"]
first-carrier
first-flight = first-row["flight"]
first-flight
first-origin = first-row["origin"]
first-origin
first-dest = first-row["dest"]
first-dest

second-row
second-carrier = second-row["carrier"]
second-carrier
second-flight = second-row["flight"]
second-flight
second-origin = second-row["origin"]
second-origin
second-dest = second-row["dest"]
second-dest