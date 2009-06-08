class CreateAssistants < ActiveRecord::Migration
  def self.up
    create_table :assistants do |t|
      t.references :user
      t.float :benefit
      t.float :other

      t.timestamps
    end
    add_index :assistants, :user_id
  end

  def self.down
    drop_table :assistants
  end
end
