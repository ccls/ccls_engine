class AddManualNumbering < ActiveRecord::Migration
  def self.up
    add_column :surveys, :manual_numbering, :boolean
    add_column :questions, :number, :string
  end

  def self.down
    remove_column :surveys, :manual_numbering
    remove_column :questions, :number
  end
end
