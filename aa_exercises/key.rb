users:
    id, fname, lname

questions:
    id, title, body, author_id
    #author_id -> users.id

question_follows:
    id, question_id, user_id
    #questions_id -> questions.id
    #user_id -> users.id

replies:
    id, body, question_id, replies_id, author_id
   
    #question_id -> questions.id
    #author_id -> users.id
    #reply_id -> replies.id

question_likes:
    id, question_id, user_id

    #questions_id -> question.id
    #user_id -> users.id




previous changes  'associated_author' changed to  'author_id'

previous changes  'replies.user_id'  changed to  'author_id'