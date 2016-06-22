class Admin::UsersController < AdminController
  before_action :find_user, except: [:index, :create, :new]
  def index
    @users = User.all
  end
  
  def edit
  end
  
  def new
    @user = User.new
  end
  
  def update
    if @user.update_attributes(user_params)
      redirect_to [:admin, :users]
    else
      render :update, notice: error_list_for(@user)
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to [:admin, :users]
    else
      render :new, notice: error_list_for(@user)
    end
  end
  
  def reset_password
    @user.send_reset_password_instructions
    redirect_to [:admin, :users], notice: "Password reset instructions sent."
  end
  
  private
  def find_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end