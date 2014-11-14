class UsersController < ApplicationController
  def new
  	@user = User.new
  	@title = "Sign Up"
  end
  def create
    @user = User.new(user_params)
    if @user.save
        sign_in @user
    	flash[:success] = "Welcome to broad Market!"
    	redirect_to @user
      # Traite un succès d'enregistrement.
    else
      @title = "Sign Up"
      render 'new'
    end
  end
    def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
