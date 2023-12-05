require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = create(:user)
  end
  describe 'validations' do
    it 'should be valid' do
      expect(@user).to be_valid
    end
    it 'name should be present' do
      @user.username = ''
      expect(@user).not_to be_valid
    end

    it 'email should be present' do
      @user.email_id = ''
      expect(@user).not_to be_valid
    end
  #
    it 'name should not be too short' do
      @user.username = 'a' * 2
      expect(@user).not_to be_valid
    end

    it 'name should not be too long' do
      @user.username = 'a' * 51
      expect(@user).not_to be_valid
    end
  #
    it 'email should not be too long' do
      @user.email_id = "#{'a' * 244}@example.com"
      expect(@user).not_to be_valid
    end
    it 'email validation should accept valid addresses' do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        @user.email_id = valid_address
        expect(@user).to be_valid
      end
    end

    it 'email validation should reject invalid addresses' do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        @user.email_id = invalid_address
        expect(@user).not_to be_valid
      end
    end

    it 'password should be present' do
      @user.password = ' ' * 6
      expect(@user).not_to be_valid
    end

    it 'password should have a minimum length' do
      @user.password = 'a' * 5
      expect(@user).not_to be_valid
    end
  end

  describe 'before_save callback' do
    it 'downcase the email before saving' do
      user = create(:user, email_id: 'USER@EXAMPLE.COM')
      expect(user.email_id).to eq('user@example.com')
    end
  end
end
