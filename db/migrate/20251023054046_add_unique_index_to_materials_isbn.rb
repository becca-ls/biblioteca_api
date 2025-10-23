class AddUniqueIndexToMaterialsIsbn < ActiveRecord::Migration[8.0]
  def change
    remove_index :materials, :isbn, if_exists: true
    add_index    :materials, :isbn, unique: true
  end
end
