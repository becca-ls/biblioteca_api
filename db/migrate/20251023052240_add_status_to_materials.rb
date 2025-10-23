class AddStatusToMaterials < ActiveRecord::Migration[8.0]
  def change
    add_column :materials, :status, :string, null: false, default: "draft"
    add_index  :materials, :status
  end
end
