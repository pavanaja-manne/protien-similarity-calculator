class AddSimilarityToTimeTaken < ActiveRecord::Migration
  def change
    add_column :time_takens, :similarity, :string
  end
end
