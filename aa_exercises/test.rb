require_relative 'question'
require_relative 'reply'
require_relative 'user'

QuestionsDatabase.open


fir_use = User.new('fname' => 'will', 'lname' => 'bannister')
sec_use = User.new('fname' => 'max', 'lname' => 'fong')
fir_use.create
sec_use.create

# Tests construction of users database

User.all

fir_quest = Question.new({'title' => 'how do you like your coffee?', 
  'body' =>'with cream', 
  'author_id' => 1}) # author is will
sec_quest = Question.new({'title' => 'how do you like your coffee?', 
    'body' =>'with cream', 
    'author_id' => 1}) # author is will
thi_quest = Question.new({'title' => 'how do you like your coffee?', 
    'body' =>'with cream', 
    'author_id' => 1}) # author is will
four_quest = Question.new({'title' => 'how do you like your coffee?', 
    'body' =>'with cream', 
    'author_id' => 1}) # author is will
  
fir_quest.create
sec_quest.create
thi_quest.create
four_quest.create

# Tests construction of questions database
Question.all


fir_repl = Reply.new({ 'body' =>'dairy has a terrible aftertaste',
  'question_id' => 3,
  'author_id' => 2
})
sec_repl = Reply.new({'body' => 'so does coffee',
'question_id' => 3,
  'reply_id' => 3,
  'author_id' => 1
})
thr_repl = Reply.new({'body' => 'black tea it is',
'question_id' => 3,
  'reply_id' => 3,
  'author_id' => 2
})
four_repl = Reply.new({'body' => '3 heaps of sugar',
  'question_id' => 3,
    'author_id' => 2 # 
})
fir_repl.create
sec_repl.create
thr_repl.create
four_repl.create

# Tests construction of replies database
Reply.all


# Test queries
Question.find_by_author_id(1) # Returns questions by author id
Reply.find_by_user_id(2) # Returns replies by user id
p Reply.find_by_question_id(1) # Replies for a specific Q (Returns replies by question id)

p User.find_by_name('max', 'fong') # Returns user instance by name 

p fir_use.authored_questions # 
p sec_use.authored_questions # 
p fir_use.authored_replies # 
p sec_use.authored_replies # 
p fir_quest.author # 
p fir_quest.replies # 
p sec_repl.author # 
p fir_repl.question # 
p sec_repl.question # 
p sec_repl.parent_reply # fir_ reply
p thr_repl.parent_reply # sec_ reply
p fir_repl.child_replies # sec_ & thr_ reply