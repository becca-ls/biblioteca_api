class CreateAuthors < ActiveRecord::Migration[8.0]
  def change
    create_table :authors do |t|
      t.string  :name, null: false
      t.integer :kind, null: false, default: 0   # 0: person, 1: institution
      t.text    :bio
      t.string  :email

      t.timestamps
    end

    add_index :authors, :kind
    add_index :authors, :email, unique: true
  end
end
