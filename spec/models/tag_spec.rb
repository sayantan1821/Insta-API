require 'rails_helper'

RSpec.describe Tag, type: :model do
  before do
    @tag = create(:tag)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(@tag).to be_valid
    end

    it 'requires a tagged_user_id' do
      expect(build(:tag, tagged_user_id: nil)).not_to be_valid
    end

    it 'requires a post_id' do
      expect(build(:tag, post_id: nil)).not_to be_valid
    end

  end
end
