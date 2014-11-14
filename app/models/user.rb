# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  email              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#
require 'digest'
class User < ActiveRecord::Base
	attr_accessor :password
	#attr_accessible :nom, :email, :password, :password_confirmation
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	# validation of first name
	validates(:first_name, :presence => true, :length   => { :maximum => 50 } )
	#validation of last name
	validates(:last_name, :presence => true, :length   => { :maximum => 50 } )
	#Validation of email	  
	validates(:email, :presence => true, :format   => { :with => email_regex },:uniqueness => { :case_sensitive => false })
	#Validation of user name	  
	validates(:user_name, :presence => true, :length   => { :maximum => 50 } )
	# Create virtuel field 'password_confirmation'.
    validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 8..40 }
	before_save :encrypt_password

	#return true if password is ok
	def has_password?(password_soumis)
			encrypted_password == encrypt(password_soumis)
	end
	#Method to check authentication
	def self.authenticate(email, submitted_password)
		    user = find_by_email(email)
		    return nil  if user.nil?
		    return user if user.has_password?(submitted_password)
	end
	#authenticate with salt key for cookies policy
	def self.authenticate_with_salt(id, cookie_salt)
			user = find_by_id(id)
			(user && user.salt == cookie_salt) ? user : nil
  	end
	private
	    def encrypt_password
	        self.salt = make_salt if new_record?
      		self.encrypted_password = encrypt(password)
	    end
	    def encrypt(string)
	      secure_hash("#{salt}--#{string}")
	    end
		def make_salt
      		secure_hash("#{Time.now.utc}--#{password}")
    	end
    	def secure_hash(string)
      		Digest::SHA2.hexdigest(string)
    	end	    
end
