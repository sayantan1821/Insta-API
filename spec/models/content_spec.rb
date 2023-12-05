require 'rails_helper'

RSpec.describe Content, type: :model do
  before do
    @content = create(:content)
  end

  describe 'validation' do
    it 'should be valid' do
      expect(@content).to be_valid
    end

    it 'requires a post_id' do
      expect(build(:content, post_id: nil)).not_to be_valid
    end

    it 'requires a content_url' do
      expect(build(:content, content_url: nil)).not_to be_valid
    end

  end
end
