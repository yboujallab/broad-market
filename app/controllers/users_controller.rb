class UsersController < ApplicationController

 before_filter :authenticate, :except => [:show, :new, :create]
 before_filter :correct_user, :only => [:edit, :update]

  #Action for new user
  def new
  	@user = User.new
  	@title = "Sign Up"
  end
  #Action to create new user
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
  #Action to show user
  def show
    @user = User.find(params[:id])
    @title = @user.first_name + " "+@user.last_name 
  end
  def edit
    #@user = User.find(params[:id])
    @titre = "Editing profil"
  end  
  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profil Updated."
      redirect_to @user
    else
      @titre = "Editing profil"
      render 'edit'
    end
  end  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :user_name,:email, :password, :password_confirmation)
  end
  private
    #def authenticate
     # deny_access unless signed_in?
    #end
      def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end  
end
