require 'rails_helper'

RSpec.describe Author, type: :model do
  describe 'associations' do
    it { should have_many(:authorships).dependent(:destroy) }
    it { should have_many(:materials).through(:authorships) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }

    it 'is valid with kind person or institution' do
      expect(Author.new(name: 'John', kind: 'person')).to be_valid
      expect(Author.new(name: 'TechCorp', kind: 'institution')).to be_valid
    end

    it 'is invalid if person has founded_year' do
      author = Author.new(name: 'John', kind: 'person', founded_year: 1999)
      expect(author).not_to be_valid
    end

    it 'is invalid if institution has birth_date' do
      author = Author.new(name: 'UFPE', kind: 'institution', birth_date: Date.new(1980, 1, 1))
      expect(author).not_to be_valid
    end
  end


  describe 'scopes' do
    it 'returns only people for .people' do
      Author.delete_all

      person = Author.create!(name: 'Alice', kind: 'person')
      Author.create!(name: 'TechCorp', kind: 'institution')

      expect(Author.people).to include(person)
      expect(Author.people.count).to eq(1)
    end
  end



end
