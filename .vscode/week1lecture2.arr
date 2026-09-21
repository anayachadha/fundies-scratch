use context starter2024
a = 'hello world '
b = a + ' ' 

string-length(a) #length of string
string-repeat(a,5) #repeats the string 5 times

"cs" + "2000"

#to convert all string characters to upper case
string-to-upper('hello cs2000')
string-toupper('hello cs2000')

#to convert all string characters to lower case
string-to-lower('WELCOME')

#to get a substring
string-substring('welcome to london',4,12)

sample_string='hello, how are you? my name is anaya, i am from london'

#to check if certain character exists in a string, value will be boolean (true or false)
string-contains(sample_string, 'anaya')

#creating images
circle(30, "solid", "light blue")
rectangle(80, 60, "solid", "pink")
triangle(90, "outline", "purple")

#composition, each of these take two images abd gives back one image
#overlay((first image) , (second image))
overlay(circle(30, "solid", "dark green") , triangle(90, "outline", "brown"))

#above((first image) , (second image))
above(circle(30, "solid", "red") , rectangle(80, 60, "solid", "orange"))

#below((first image) , (second image))
below(rectangle(80, 60, "solid", "black") , triangle(90, "outline", "yellow"))

#beside((first image) , (second image))
beside(circle(30, "solid", "dark blue") , triangle(90, "outline", "white"))

