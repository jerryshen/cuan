class CreateBankCards < ActiveRecord::Migration
  def self.up
    create_table :bank_cards do |t|
      t.references :user
      t.references :bank
      t.string :card_number
      t.text :description

      t.timestamps
    end
    add_index :bank_cards, :user_id
    add_index :bank_cards, :bank_id
  end

  def self.down
    drop_table :bank_cards
  end
end
