#+------------+--------------+------+-----+---------+----------------+
#| Field      | Type         | Null | Key | Default | Extra          |
#+------------+--------------+------+-----+---------+----------------+
#| id         | int(11)      | NO   | PRI | NULL    | auto_increment |
#| name       | varchar(255) | YES  |     | NULL    |                |
#| function   | varchar(255) | YES  |     | NULL    |                |
#| url        | varchar(255) | YES  |     | NULL    |                |
#| module_id  | int(11)      | YES  | MUL | NULL    |                |
#| hidden     | tinyint(1)   | YES  |     | NULL    |                |
#| created_at | datetime     | YES  |     | NULL    |                |
#| updated_at | datetime     | YES  |     | NULL    |                |
#+------------+--------------+------+-----+---------+----------------+
class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages  do |t|
      t.string :name
      t.text :function
      t.string :url
      t.references :page_module
      t.boolean :hidden

      t.timestamps
    end
    add_index :pages, :page_module_id
  end

  def self.down
    drop_table :pages
  end
end
