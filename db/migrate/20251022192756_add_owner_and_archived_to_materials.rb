class AddOwnerAndArchivedToMaterials < ActiveRecord::Migration[8.0]
  def up
    
    add_reference :materials, :user, null: true, foreign_key: true

    add_column :materials, :archived, :boolean, default: false, null: false

 
    execute <<~SQL
      UPDATE materials
      SET user_id = (SELECT id FROM users ORDER BY id LIMIT 1)
      WHERE user_id IS NULL;
    SQL

  
    change_column_null :materials, :user_id, false
  end

  def down
    remove_column :materials, :archived
    remove_reference :materials, :user, foreign_key: true
  end
end
