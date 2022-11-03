require_relative 'question'
require_relative 'questions_database'
require_relative 'reply'


class User
    attr_accessor :id, :fname, :lname
    
    def self.all
        data = QuestionsDatabase.execute("SELECT * FROM users")
        data.map { |datum| User.new(datum) }
    end

    
    def self.find_by_name(fname, lname)
        user = QuestionsDatabase.execute(<<-SQL, fname, lname)
        SELECT
            *
        FROM
            users
        WHERE
            fname = ? and lname = ? 
        SQL

        return nil if user == []
        User.new(user.first)
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def create
        raise "#{self.id} not found in DB" if self.id
        QuestionsDatabase.execute(<<-SQL, self.fname, self.lname)
            INSERT INTO
                users (fname, lname)
            VALUES
                (?, ?)
        SQL
        self.id = QuestionsDatabase.last_insert_row_id
    end

    def update
        raise "#{self.id} not found in DB" unless self.id
        QuestionsDatabase.execute(<<-SQL, self.fname, self.lname, self.id)
            UPDATE
                users
            SET
                fname=?, lname=?
            WHERE
                id=?
        SQL
    end

    def authored_questions #should use Question::find_by_author_id
        raise "#{self.id} not found in DB" unless self.id
        Question.find_by_author_id(self.id)
    end

    def authored_replies
        raise "#{self.id} not in DB" unless self.id
        Reply.find_by_user_id(self.id)
    
    end

end