require_relative "../config/environment.rb"

class Student
  
  attr_accessor :name, :grade
  attr_reader :id
  @@all = []
  
  def self.all
    @@all
  end
  
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
  end
  
  def self.create_table
    sql = <<-SQL
     CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT)
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end
  
  def save
    sql_insert = "INSERT INTO students(name, grade) VALUES(?,?)"
    sql_select = "SELECT * FROM students"
    sql_update = "UPDATE students SET name = #{self.name} WHERE id = #{self.id}"
    
    if self.id !=nil # If id not nil - we know object has already been persisted
      DB[:conn].execute(sql_update)
    end
    
    if self.id == nil
       DB[:conn].execute(sql_insert, self.name, self.grade)
       @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end
      
  def self.create(name:, grade:)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end
  
  
  
  
  
  
  
  
  
  
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
