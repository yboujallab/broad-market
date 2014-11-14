class SessionsController < ApplicationController
  def new
  	@title = "Sign up"
  end
  def create
  	  user = User.authenticate(params[:session][:email],
                           	   params[:session][:password])
      if user.nil?
        # Create an error message
          flash.now[:error] = "Invalid Email/Password"
          @title = "Sign up"
          render 'new'
      else
        # Authenticate user and redirect him 
          sign_in user
          redirect_back_or user
      end
  end
  def destroy
	  sign_out
    redirect_to root_path
  end
end
