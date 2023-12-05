require 'rails_helper'

RSpec.describe Like, type: :model do
  before do
    @like = create(:like)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(@like).to be_valid
    end

    it 'requires a user id' do
      expect(build(:like, liked_by_user_id: nil)).not_to be_valid
    end

    it 'requires a post id' do
      expect(build(:like, post_id: nil)).not_to be_valid
    end

  end
end
