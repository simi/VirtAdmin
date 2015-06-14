require 'test_helper'

describe ApproveUserService do
  before do
    @user = FactoryGirl.create :user, approved: false
  end

  it 'approves users when global settings is off' do
    Settings.users.manual_approval = false
    ApproveUserService.new(@user).must_be :approve
  end

  it "won't approve users when global settings is on" do
    Settings.users.manual_approval = true
    ApproveUserService.new(@user).wont_be :approve
  end

  it 'approve user based on policy' do
    Settings.users.manual_approval = 'auto'
    @user.name = 'Bill Gates'
    ApproveUserService.new(@user).wont_be :approve

    @user.disapprove!
    @user.name = 'Jaromír Červenka'
    @user.country = 'CZ'

    ApproveUserService.new(@user, '77.75.76.3').must_be :approve
  end
end
