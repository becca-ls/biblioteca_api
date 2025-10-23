class Material < ApplicationRecord
  belongs_to :user
  has_many :authorships, dependent: :destroy
  has_many :authors, through: :authorships

  validates :title, presence: true
  validate  :typed_fields
  # Atributos que a busca Ransack pode usar
  def self.ransackable_attributes(_auth_object = nil)
    %w[
      id title description published_at isbn url type user_id archived
      created_at updated_at
    ]
  end

  # (Opcional) Quais associações podem ser usadas na busca
  def self.ransackable_associations(_auth_object = nil)
    %w[authorships authors user]
  end
  private

  def typed_fields
    case type
    when 'Book'
      errors.add(:isbn, "can't be blank for books") if isbn.blank?
    when 'Article', 'Video'
      errors.add(:url, "can't be blank for #{type.downcase.pluralize}") if url.blank?
    end
  end
end

