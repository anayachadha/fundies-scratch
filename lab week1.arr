use context starter2024
#1. T-SHIRT SHOP
#calculating cost
(12 * 5) + 3
(12 * 7) + 3
87 - 63
# 7 Tshirts cost £24 more than 5 T-shirts.

#rectangular poster
(2 * (420 + 594)) * 0.10

#if no parentheses it gives an error - 2 * 420 + 594

#2. STRING SURPRISES
#saving a tagline
"Designs for everyone!"

#error
"designs for everyone!

#fixing error
"designs for everyone!"

#colour inventory
('red' + 'blue')
#(1 + 'blue') #=> gives an error, as the + operator expects to be given either two numbers or two strings

#3. TRAFFIC LIGHTS
red = circle(15, "solid", "red")
yellow = circle(15, "solid", "yellow")
green = circle(15, "solid", "green")

lights = above(red, above(yellow, green))

body = rectangle(50, 120, "solid", "black")

light = overlay(lights, body)

pole = rectangle(10, 50, "solid", "black")

final = above(light, pole)
final

#4 BROKEN CODE HUNT
#broken code - rectangle(50, "solid", 20, "black")
#fixed code
rectangle(50, 20, "solid", "black")

#error since solid needs to be in a string - circle(30, solid, "red")
#fixed code
circle(30, 'solid', 'red')

#5. CREATE A SHIELD OR FLAG
#SHEILD
shield = rotate(45, square(100, "solid", "gray"))
emblem = circle(30, "solid", "gold")
label = text("GO!", 20, "black")
shieldandemblem = overlay(emblem, shield)
finalshield = overlay(label, shieldandemblem)
finalshield