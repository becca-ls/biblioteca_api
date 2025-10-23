class AddOwnerAndArchivedToMaterials < ActiveRecord::Migration[8.0]
  def up
    # 1) cria a coluna user_id permitindo NULL (para não quebrar registros existentes)
    add_reference :materials, :user, null: true, foreign_key: true

    # 2) cria 'archived' com default false
    add_column :materials, :archived, :boolean, default: false, null: false

    # 3) preenche user_id nos materiais já existentes com “algum” usuário
    #    (pega o primeiro usuário da tabela)
    execute <<~SQL
      UPDATE materials
      SET user_id = (SELECT id FROM users ORDER BY id LIMIT 1)
      WHERE user_id IS NULL;
    SQL

    # 4) agora pode travar como NOT NULL
    change_column_null :materials, :user_id, false
  end

  def down
    remove_column :materials, :archived
    remove_reference :materials, :user, foreign_key: true
  end
end
