require 'sqlite3'
require_relative 'questions_database.rb'

class Reply
  attr_accessor :id, :body, :question_id, :reply_id, :author_id

  def self.all 
    data = QuestionsDatabase.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
  end
  
  def self.find_by_user_id(user)
    user = QuestionsDatabase.execute(<<-SQL, user)
      SELECT 
        *
      FROM 
        replies
      WHERE 
        author_id=?
    SQL
    user.map{|use| Reply.new(use)}
  end
  
  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.execute(<<-SQL, question_id)
      SELECT
          *
      FROM
          replies
      WHERE
          question_id = ?
    SQL
    data.map{|datum| Reply.new(datum)}
  end

  def initialize(options)
    @id = options['id']
    @body = options['body']
    @question_id = options['question_id']
    @reply_id = options['reply_id']
    @author_id = options['author_id']
  end

  def create
    raise "#{self} already in database" if self.id
    QuestionsDatabase.execute(<<-SQL, self.body, self.question_id, self.reply_id, self.author_id)
      INSERT INTO
        replies (body, question_id, reply_id, author_id)
      VALUES
        (?, ?, ?, ?)
    SQL
    self.id = QuestionsDatabase.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless self.id
    QuestionsDatabase.execute(<<-SQL, self.body, self.question_id, self.reply_id, self.author_id)
      UPDATE
        replies
      SET
        body=?, question_id=?, reply_id=?, author_id=?
      WHERE
        id=?
    SQL
  end

  def author
    self.author_id
  end

  def question
    QuestionsDatabase.execute(<<-SQL, self.question_id)
      select *
      from questions
      where id=?
    SQL
  end

  def parent_reply
    data = QuestionsDatabase.execute(<<-SQL, self.reply_id)
        SELECT
            * --question_id
        FROM
            replies
        WHERE
            id = ?
    SQL

    return nil unless data.length > 0
    Reply.new(*data)
end

  def child_replies #Only do child replies one-deep; don't find grandchild comments.
    data = QuestionsDatabase.execute(<<-SQL, self.id) 
        SELECT 
           *
        FROM 
          replies
        WHERE 
          reply_id = ? 
    SQL

    return nil unless data.length > 0
    data.map {|datum| Reply.new(datum)}
  end
end