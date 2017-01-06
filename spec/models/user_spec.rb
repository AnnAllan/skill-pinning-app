require 'spec_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  before(:all) do
	@user = User.create(email: "coder@skillcrush", password: "password")
  end
  
  after(:all) do
	if !@user.destroyed?
		@user.destroy
	end
  end
  
  it 'authenticates and returns a user when valid email and password passed in' do
	User.authenticate(@user.email,@user.password)
	expect(@user).to eql(@user)
  end
  
  it {should validate_presence_of(:first_name)}
  it {should validate_presence_of(:last_name)}
  it {should validate_presence_of(:email)}
  it {should validate_presence_of(:password)}
end
