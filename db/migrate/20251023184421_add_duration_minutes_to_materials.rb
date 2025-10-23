class AddDurationMinutesToMaterials < ActiveRecord::Migration[8.0]
  def change
    add_column :materials, :duration_minutes, :integer
  end
end
