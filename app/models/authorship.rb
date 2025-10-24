class Authorship < ApplicationRecord
  belongs_to :author
  belongs_to :material, inverse_of: :authorships


  ROLES = %w[author editor translator].freeze
  validates :role, presence: true, inclusion: { in: ROLES }
end
