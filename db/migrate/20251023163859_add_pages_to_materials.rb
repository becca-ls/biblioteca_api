class AddPagesToMaterials < ActiveRecord::Migration[8.0]
  def change
    add_column :materials, :pages, :integer
  end
end