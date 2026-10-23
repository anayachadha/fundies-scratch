use context dcic2024
data My-Post:
    post(username :: String, caption :: String, likes :: Number, shares :: Number)
end

post-1 = post('@climate_now', 'article sea ice hits a record low', 1250, 340)
post-2 = post('@cityfarm', 'our rooftop garden this week', 85, 4)
post-3 = post('@nu_london', 'welcome to week 6!', 410, 12)

feed :: List<My-Post> = [list: post-1, post-1, post-1]

post-1.likes
post-2.username
feed.length()

#functions over a post
fun engagement(p :: My-Post) -> Number:
  doc: 'likes plus shares for a post'
  p.likes 
end 
  
fun is-viral(p :: My-Post) -> Boolean:
  doc: 'true when a post has more than 1000 likes'
    p.likes > 1000
where:
    is-viral(post-1) is true
    is-viral(post-2) is false
    is-viral(post('@JamesBond', 'hello, my name is james bond', 1000, 50)) is false
end
  
#conditional data
  
#priority: vartiants with no field
data Priority:
    | low
    | medium
    | high
end
  
task-1-Priority = low
task-2-Priority = medium
task-3-Priority = high
  
check:
    is-Priority(task-1-priority) is true
    is-low(task-1-priority) is true
    is-medium(task-3-priority) is false
    s-high(task-3-priority) is true
end

#task: variants with fields
data Task: 
  | task(description :: String, priority :: Priority)
  | note(description :: String)
end

task-1 = task('buy groceries', high)
task-2 = task('pay council tax', high)
task-3 = note('PDI exam is on october 30th')

task-1.priority
note-1.description
is-task(task-1) #cheching if there's a task in task 1
is-note(task-1) #cheching if there's a note in task 1

#describe 
fun describe(t :: Task) -> String:
  cases (Task) t:
    | task(d, p) => 'TASK: ' + d
    | note(d) => 'NOTE: ' + d
  end
end

#the task(d, p) pattern must have one name per field, in order
#the note branch has one name because it has one field

describe(task-1)
describe(note-1)

fun is-urdent(t :: Task) -> Boolean:
  doc: 'true for a task with high priority; notes are never urgent'
  cases (Task) t:
    | task(d, p) => is-high(p)
    | else => false
  end
where:
  is-urgent(task-2) is true
  is-urgent(task-1) is true
  is-urgent(note-1) is false
end

#a variant with no branch
fun describe-again(t :: Task) -> String:
  cases (Task) t:
    | task(d, p) => "TASK: " + d
  end
end 
describe-again(task-1)
describe-again(note-1)