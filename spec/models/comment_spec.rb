require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = create(:comment)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(@comment).to be_valid
    end

    it 'requires a commentator_id' do
      expect(build(:comment, commentator_id: nil)).not_to be_valid
    end

    it 'requires a post_id' do
      expect(build(:comment, post_id: nil)).not_to be_valid
    end
  end
end
