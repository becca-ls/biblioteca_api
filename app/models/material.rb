class Material < ApplicationRecord
  belongs_to :user
  has_many :authorships, dependent: :destroy
  has_many :authors, through: :authorships
  enum :status, { draft: "draft", published: "published", archived: "archived" }
  validates :status, inclusion: { in: statuses.keys }
  validates :title, presence: true, length: { in: 3..100 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validate  :typed_fields
  # Atributos que a busca Ransack pode usar
  def self.ransackable_attributes(_auth_object = nil)
  %w[
    title description status isbn url type user_id
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
      if isbn.blank? || !(isbn.to_s =~ /\A\d{13}\z/)
        errors.add(:isbn, "must be exactly 13 numeric digits")
      end
      if pages.blank? || pages.to_i <= 0
        errors.add(:pages, "must be an integer greater than 0")
      end

    when 'Article'
      if doi.blank? || !(doi.to_s =~ /\A10\.\d{4,9}\/[-._;()\/:A-Z0-9]+\z/i)
        errors.add(:doi, "is invalid")
      end
      errors.add(:url, "can't be blank for articles") if url.blank?

    when 'Video'
      if duration_minutes.blank? || duration_minutes.to_i <= 0
        errors.add(:duration_minutes, "must be an integer greater than 0")
      end
      errors.add(:url, "can't be blank for videos") if url.blank?
    end
  end

end

