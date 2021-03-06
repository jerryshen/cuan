#+-------------+--------------+------+-----+---------+----------------+
#| Field       | Type         | Null | Key | Default | Extra          |
#+-------------+--------------+------+-----+---------+----------------+
#| id          | int(11)      | NO   | PRI | NULL    | auto_increment |
#| name        | varchar(255) | YES  |     | NULL    |                |
#| description | text         | YES  |     | NULL    |                |
#| created_at  | datetime     | YES  |     | NULL    |                |
#| updated_at  | datetime     | YES  |     | NULL    |                |
#+-------------+--------------+------+-----+---------+----------------+
class CreatePageModules < ActiveRecord::Migration
  def self.up
    create_table :page_modules  do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :page_modules
  end
end
