require "pry"
class Dog

attr_accessor  :name, :breed, :id

def initialize(name:, breed:, id: nil)
    @id = id
    @name = name
    @breed = breed
    
end

def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT)"
    DB[:conn].execute(sql)
end
def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"
    DB[:conn].execute(sql)
end
def save
    sql="INSERT INTO dogs (name,breed) VALUES (?,?)"
    DB[:conn].execute(sql, self.name, self.breed)
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
end
def self.create(name:, breed:)
    name = Dog.new(name: name, breed: breed)
    name.save
end
def self.new_from_db(row)
    # binding.pry
    self.new(id: row[0], name: row[1], breed: row[2])
end
def self.all
    DB[:conn].execute("SELECT * FROM dogs").map do |row|
        self.new_from_db(row)
    end
end
def self.find_by_name(name)
    DB[:conn].execute("SELECT * FROM dogs WHERE name = ? LIMIT 1",name).map do |row|
        # binding.pry
        self.new_from_db(row)
        
    end.first
end
def self.find (id)
    DB[:conn].execute("SELECT * FROM dogs WHERE id = ? LIMIT 1",id).map do |row|
        # binding.pry
        self.new_from_db(row)
        
    end.first
end
end
