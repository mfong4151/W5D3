require 'sqlite3'
require_relative 'questions_database.rb'



class Question
    attr_accessor :id, :title, :body, :author_id
    
    def self.all
        data = QuestionsDatabase.execute("SELECT * FROM questions")
        data.map { |datum| User.new(datum) }
    end


    def self.find_by_id(id)

        question = QuestionsDatabase.execute(<<-SQL,  id)
        SELECT
            * 
        FROM
            questions
        WHERE
            id = ?
        SQL

        question.map{|datum| Question.new(datum)}
        
        return nil unless question.length > 0
        Question.new(question.first) #????
    end

    def self.find_by_author_id(author_id) #a/a refer to this as "author_id"    
        questions = QuestionsDatabase.execute(<<-SQL, author_id)
        
        SELECT
            title, body --Do we need the title and body?
        FROM
            questions
        WHERE
            author_id = ?
        SQL

        # bc warpped in arr
     
        questions.map { |datum| Question.new(datum) }
    end

    def self.all
        data = QuestionsDatabase.execute('SELECT * FROM questions')
        data.map { |datum| Question.new(datum) }
    end
    

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def create
        raise "#{self} already in database" if self.id
        QuestionsDatabase.execute(<<-SQL, self.title, self.body, self.author_id)
            INSERT INTO
                questions (title, body, author_id)
            VALUES
                (?, ?, ?)
        SQL
        self.id = QuestionsDatabase.last_insert_row_id
    end

    def update
        raise "#{self} already in database" unless self.id
        QuestionsDatabase.execute(<<-SQL, self.title, self.body, self.author_id, self.id)
            UPDATE
                questions
            SET
                title=?, body=?, author_id=?
            WHERE
                id=?
        SQL
    end

    def author
        data = QuestionsDatabase.execute(<<-SQL, self.author_id)
            SELECT *
            FROM users
            where id=? 
        SQL
        return nil unless data.length > 0
        User.new(data.first)
    end
    
    def replies
        ###################################
        # use Reply::find_by_question_id
        Reply.find_by_question_id(self.id)
    end



    




    
end