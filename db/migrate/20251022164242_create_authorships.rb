class CreateAuthorships < ActiveRecord::Migration[7.1]
  def change
    create_table :authorships do |t|
      t.references :author,   null: false, foreign_key: true
      t.references :material, null: false, foreign_key: true
      t.string :role
      t.timestamps
    end

    add_index :authorships, [:author_id, :material_id], unique: true
  end
end
