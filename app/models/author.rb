class Author < ApplicationRecord
  enum :kind, { person: 0, institution: 1 }

  has_many :authorships, dependent: :destroy
  has_many :materials, through: :authorships

  validates :name, presence: true
  validates :email, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
