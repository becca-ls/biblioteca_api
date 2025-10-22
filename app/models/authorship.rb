class Authorship < ApplicationRecord
  belongs_to :author
  belongs_to :material

  validates :author_id, uniqueness: { scope: :material_id }
end
