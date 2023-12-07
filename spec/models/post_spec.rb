require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    @post = create(:post)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(@post).to be_valid
    end

    it 'requires a creator' do
      expect(build(:post, creator_id: nil)).not_to be_valid # db entry save fail
    end

    # it 'requires a caption' do
    #   expect(build(:post, caption: nil)).not_to be_valid # db entry save fail
    # end
    #
    # it 'requires a location' do
    #   expect(build(:post, location: nil)).not_to be_valid # db entry save fail
    # end

  end
end
