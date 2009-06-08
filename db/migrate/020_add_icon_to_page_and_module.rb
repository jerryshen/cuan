class AddIconToPageAndModule < ActiveRecord::Migration
  def self.up
    add_column :page_modules, :icon, :string
    add_column :pages, :icon, :string
  end

  def self.down
    remove_column :page_modules, :icon
    remove_column :pages, :icon
  end
end
