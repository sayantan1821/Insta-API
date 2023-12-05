require 'rails_helper'

RSpec.describe Follower, type: :model do
  before do
    @follower = create(:follower)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(@follower).to be_valid
    end

    it 'requires a follower user' do
      expect(build(:follower, follower_user_id: nil)).not_to be_valid
    end

    it 'requires a following user' do
      expect(build(:follower, following_user_id: nil)).not_to be_valid
    end

  end
end
