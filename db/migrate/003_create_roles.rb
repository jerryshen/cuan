#+------------+--------------+------+-----+---------+----------------+
#| Field      | Type         | Null | Key | Default | Extra          |
#+------------+--------------+------+-----+---------+----------------+
#| id         | int(11)      | NO   | PRI | NULL    | auto_increment |
#| name       | varchar(255) | YES  |     | NULL    |                |
#| created_at | datetime     | YES  |     | NULL    |                |
#| updated_at | datetime     | YES  |     | NULL    |                |
#+------------+--------------+------+-----+---------+----------------+
class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end
