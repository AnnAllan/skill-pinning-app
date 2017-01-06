class User < ActiveRecord::Base
	has_many :pinnings, inverse_of: :user, dependent: :destroy
	has_many :pins, through: :pinnings
	has_many :boards, inverse_of: :user, dependent: :destroy
	has_secure_password
	validates_presence_of :first_name, :last_name, :email, :password
	validates_uniqueness_of :email
	
	def self.authenticate(email, password)
		@user = User.find_by_email(email)
		if !@user.nil?
			if @user.authenticate(password)
				return @user
			end
		end
		return nil
	end
end
