use context dcic2024
include csv
#|
   PROBLEM 1
fun leap-year(year :: Number) -> Boolean:
  doc: "determines whether a given year is a leap year or not"
  if 
|#

#PROBLEM 2
fun tick(seconds :: Number) -> Number:
  doc: "returns the next second in a minute"
  if seconds == 59:
    0
  else:
    seconds + 1
  end
where:
  tick(0) is 1
  tick(1) is 2
  tick(30) is 31
  tick(58) is 59
  tick(59) is 0
end

#PROBLEM 3
fun rock-paper-scissors(player1 :: String, player2 :: String) -> String:
  doc: "returns the winner of a rock-paper-scissors game, or invalid choice if either player makes an invalid choice"
  if (player1 != "rock" and player1 != "paper" and player1 != "scissors") or
     (player2 != "rock" and player2 != "paper" and player2 != "scissors"):
    "invalid choice"
  else if player1 == player2:
    "tie"
  else if (player1 == "rock" and player2 == "scissors") or
          (player1 == "paper" and player2 == "rock") or
          (player1 == "scissors" and player2 == "paper"):
    "player 1"
  else:
    "player 2"
  end
where:
  rock-paper-scissors("rock", "rock") is "tie"
  rock-paper-scissors("rock", "paper") is "player 2"
  rock-paper-scissors("rock", "scissors") is "player 1"
  rock-paper-scissors("paper", "rock") is "player 1"
  rock-paper-scissors("paper", "paper") is "tie"
  rock-paper-scissors("paper", "scissors") is "player 2"
  rock-paper-scissors("scissors", "rock") is "player 2"
  rock-paper-scissors("scissors", "paper") is "player 1"
  rock-paper-scissors("scissors", "scissors") is "tie"
  rock-paper-scissors("banana", "rock") is "invalid choice"
  rock-paper-scissors("rock", "banana") is "invalid choice"
end

#PROBLEM 4
planets = table: planet :: String, distance :: Number
  row: 'mercury', 0.39
  row: 'venus', 0.72
  row: 'earth', 1
  row: 'mars', 1.52
  row: 'jupiter', 5.2
  row: 'saturn', 9.54
  row: 'uranus', 19.2
  row: 'neptune', 30.06
end
planets
mars = planets.row-n(3)
mars
mars['distance']
    

#PROBLEM 5
something = load-table:
  date :: String, rate :: Number
  source: csv-table-url('https://nulondon.instructure.com/courses/7350/files/1666718?wrap=1', default-options)
  sanitize rate using num-sanitizer
end

something.length()
median(something, 'rate')
modes(something, 'rate')
order-by(something, 'rate', true)
order-by(something, 'rate', false)