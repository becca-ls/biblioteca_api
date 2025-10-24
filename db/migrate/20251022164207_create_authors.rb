class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors do |t|
      t.string  :name, null: false
      t.string  :kind, null: false             
      t.string  :city
      t.date    :birth_date                     
      t.integer :founded_year               

      t.timestamps
    end

    add_index :authors, [:name, :kind]
  end
end
