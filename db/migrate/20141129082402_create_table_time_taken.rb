class CreateTableTimeTaken < ActiveRecord::Migration
  def change
    create_table :time_takens do |t|
      t.string :file1
      t.string :file2
      t.string :time
      t.string :method
    end
  end
end
