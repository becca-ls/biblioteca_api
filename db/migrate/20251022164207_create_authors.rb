class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors do |t|
      t.string  :name, null: false
      t.string  :kind, null: false               # "person" ou "institution"
      t.string  :city
      t.date    :birth_date                      # se for pessoa
      t.integer :founded_year                    # se for instituição

      t.timestamps
    end

    add_index :authors, [:name, :kind]
  end
end
