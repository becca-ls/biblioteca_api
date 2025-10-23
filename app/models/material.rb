class Material < ApplicationRecord
  belongs_to :user
  has_many :authorships, dependent: :destroy
  has_many :authors, through: :authorships

  validates :title, presence: true
  validate  :typed_fields

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

