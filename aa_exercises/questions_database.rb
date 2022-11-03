require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  
  def self.open
      @db = super('questions.db')
      @db.type_translation = true
      @db.results_as_hash = true
  end 

  # def self.instance
  #   @db
  # end

  def self.execute(*query)
    @db.execute(*query)
  end

  def self.last_insert_row_id
    @db.last_insert_row_id
  end
end