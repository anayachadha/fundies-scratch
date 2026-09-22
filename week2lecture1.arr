use context starter2024
#radius below is a name
#we can read the following line as 'radius is defined to be 9'
radius=9 #this complete statement is a definition
#statement - code that instructs rather than computes (definition is a statement)
#few more examples of definition
books-quantiy=5
height=180
weight=70

#expression - code that computes something
bmi-a= weight * height
bmi-a

#for multiple inputs, we use lists
#weight-list = [20, 30, 40, 50, 90, 120]

#define width
rect-width = 140

#define lenght
rect-lenght = 40

flag-before = above(rectangle(rect-width, rect-lenght,'solid','pink') , rectangle(rect-width, rect-lenght,'solid','lavender'))
flag-before

#CLASS EXERCISE
#1
triangle-lenght = 35
orange-triangle = triangle(triangle-lenght, 'solid', 'orange')
orange-triangle

#2
side-lenght = 40
colour = 'blue'
names-square = square(side-lenght,'outline', colour)

#3
plain-square = square(40,'outline', 'blue')

#example of using check
check 'same image, different code':
  names-square is plain-square
end

#4
#side-lenght = 60
#square(side-lenght, 'outline', 'blue')

#5
overlay(circle(10, 'solid', 'yellow'), rectangle(80,90,'solid','black'))

circle-radius = 10
circle-colour = 'yellow'
rectangle-lenght = 80
rectangle-width = 90
rectangle-colour = 'black'
overlay(circle(circle-radius, 'solid', circle-colour), rectangle(rectangle-lenght,rectangle-width,'solid',rectangle-colour))

#7
circle-beside = beside(circle(circle-radius, 'solid', circle-colour), circle(circle-radius, 'solid', circle-colour))
overlay(circle-beside, rectangle(rectangle-lenght,rectangle-width,'solid',rectangle-colour))

#or

overlay(beside(circle(10, 'solid', 'yellow'), circle(10, 'solid', 'yellow')) , rectangle(rectangle-lenght,rectangle-width,'solid',rectangle-colour))

#8
shield = rotate(45, square(100, "solid", "gray"))
emblem = circle(30, "solid", "gold")
label = text("GO!", 20, "black")
shieldandemblem = overlay(emblem, shield)
finalshield = overlay(label, shieldandemblem)
finalshield