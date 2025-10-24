class ChangeKindToStringInAuthors < ActiveRecord::Migration[8.0]
  def up
    change_column :authors, :kind, :string, using: 'kind::text'
  end

  def down
    change_column :authors, :kind, :integer, using: 'kind::integer'
  end
end
