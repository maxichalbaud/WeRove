class AddTitleToRecommendations < ActiveRecord::Migration[5.2]
  def change
    add_column :recommendations, :title, :string
  end
end
