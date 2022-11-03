DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;

PRAGMA foreign_keys = ON; 

--Add a users table.
    --Track the fname and lname attributes.



CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL

); 


--Add a questions table.
  --Track the title, the body, and the associated author (a foreign key).

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);



--Add a question_follows table.
    --This should support the many-to-many relationship between questions and users (a user can have many questions she is following, and a question can have many followers).
    --This is an example of a join table; the rows in question_follows are used to join users to questions and vice versa.

CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

--Add a replies table.
    --Each reply should contain a reference to the subject question.
    --Each reply should have a reference to its parent reply.
    --Each reply should have a reference to the user who wrote it.
    --Don't forget to keep track of the body of a reply.
    --"Top level" replies don't have any parent, but all replies have a subject question.
    --It's okay for a column to be self referential; a foreign key can point to a primary key in the same table.

CREATE TABLE replies(

    id INTEGER PRIMARY KEY,
    body TEXT NOT NULL,
    question_id INTEGER NOT NULL,
    reply_id INTEGER,
    author_id INTEGER NOT NULL, 


    FOREIGN KEY (author_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (reply_id) REFERENCES replies(id)

);


--Add a question_likes table.
    --Users can like a question.
    --Have references to the user and the question in this table


CREATE TABLE question_likes(
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO 
    users(fname, lname)
VALUES
    ('max', 'fong'),
    ('will', 'bannister');

INSERT INTO
    questions(title, body, author_id)
VALUES
    ('Why is the earth round?', 'I believe the earth is flat', 2),
    ('Why is ruby shit?', 'Ruby is dog shit', 1);

INSERT INTO
    question_follows(question_id, user_id)

VALUES
    (1, 2),
    (2, 1);

INSERT INTO
    replies(body, question_id, reply_id, author_id)

VALUES

    ('Kyrie Irving told me the earth wasn''t round', 1, null, 1),
    ('Ruby sucks, I agree', 2, null, 2);


INSERT INTO
    question_likes(question_id, user_id)

VALUES
    (1, 1),
    (1, 2);
