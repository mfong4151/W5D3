def self.find_by_id(id)
    question = QuestionDBConnection.instance.execute(<<-SQL,  id)
    SELECT
        * 
    FROM
        questions
    WHERE
        id = ?
    SQL
    return nil unless question.length > 0 
    Question.new(question)
end

def self.find_by_associated_author(associated_author) #a/a refer to this as "author_id"
    question = QuestionDBConnection.instance.execute(<<-SQL, associated_author)
    SELECT
        title, body --Do we need the title and body?
    FROM
        questions
    WHERE
        associated_author = ?
    SQL
    return nil if not question.length > 0
    Question.new(question)
end

def self.find_by_question_id(question_id)
    reply = QuestionDBConnection.instance.execute(<<-SQL, question_id)
    SELECT
        *
    FROM
        replies
    WHERE
        question_id = ?

    SQL
    return nil if not reply.length > 0
    Reply.new(reply)
end

def authored_replies
    raise "#{self.id} not in DB" unless self.id
    Reply.find_by_user_id(self.id)

end


def parent_reply
    parent = QuestionsDatabase.execute(<<-SQL, self.question_id)
        SELECT
            id
        FROM
            replies
        WHERE
            replies_id = ?
    SQL

    return nil unless parent.length > 0


end


def child_replies #Only do child replies one-deep; don't find grandchild comments.
    child = QuestionsDatabase.execute(<<-SQL, self.question_id)
        SELECT 
            reply_id
        FROM 
            replies
        WHERE 
            question_id = ?
    SQL 
    
    return nil unless child.length > 0
    Reply.new(child)
end