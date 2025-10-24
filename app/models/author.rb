class Author < ApplicationRecord
  KINDS = %w[person institution].freeze

  has_many :authorships, dependent: :destroy
  has_many :materials, through: :authorships

  enum :kind, { person: "person", institution: "institution" }, prefix: true

 
  validates :name, presence: true, uniqueness: { scope: :kind }

  validate :consistent_attributes

  scope :people,       -> { where(kind: "person") }
  scope :institutions, -> { where(kind: "institution") }

  private
  def consistent_attributes
    if kind == "person" && founded_year.present?
      errors.add(:founded_year, "is only for institutions")
    end
    if kind == "institution" && birth_date.present?
      errors.add(:birth_date, "is only for people")
    end
  end
end
