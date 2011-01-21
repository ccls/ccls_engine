class AddAbstractsCountToSubjects < SharedMigration
  def self.up
    add_column :subjects, :abstracts_count, :integer, :default => 0
  end

  def self.down
    remove_column :subjects, :abstracts_count
  end
end
