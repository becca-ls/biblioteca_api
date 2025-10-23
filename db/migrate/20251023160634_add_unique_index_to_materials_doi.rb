class AddUniqueIndexToMaterialsDoi < ActiveRecord::Migration[8.0]
  def change
    # garante que a coluna exista antes do índice
    add_column :materials, :doi, :string unless column_exists?(:materials, :doi)

    remove_index :materials, :doi, if_exists: true
    add_index    :materials, :doi, unique: true
  end
end
