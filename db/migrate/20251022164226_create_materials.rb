class CreateMaterials < ActiveRecord::Migration[8.0]
  def change
    create_table :materials do |t|
      t.string :type,  null: false  
      t.string :title, null: false
      t.text   :description
      t.date   :published_at
      t.string :isbn
      t.string :url

      t.timestamps
    end

    add_index :materials, :type
    add_index :materials, :title
    add_index :materials, :isbn, unique: true
  end
end
