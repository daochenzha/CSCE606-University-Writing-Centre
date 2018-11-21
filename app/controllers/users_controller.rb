class UsersController < ApplicationController

  before_action :login_req, only: [:index, :show, :update, :destroy, :admin]

  def new
    @user = User.new
  end

  def index
    @quote = Quote.get
    @user = User.find(session[:user_id])
    @user_tasks = @user.tasks
  end

  def create
    @user = User.new(param_req)
    if @user.save
      flash[:success] = "Account Created successfully, Please check your email for Verification"
    else
      flash[:error] = "Invalid Credentials"
    end
    redirect_to :login
  end

  def admin
    if !User.is_admin session[:user_id]
      redirect_to users_path
    end
    @tasks = Task.all.group(:updated_at).count
    @tasks.keys.each do |t|
      if @tasks.has_key? t.to_date
        @tasks[t.to_date] += @tasks[t]
      else
        @tasks[t.to_date] = @tasks[t]
      end
      @tasks.delete(t)
    end
  end

  def login
    # Only to render loginpage
    if session[:user_id] != nil
      redirect_to users_path
    end
  end

  def logout
    session.clear
    render :login
  end

  def auth
    authorized_user = User.authenticate(params[:user_auth][:email],params[:user_auth][:password])
    if authorized_user
      if !authorized_user.confirm
        flash[:error] = "Account has not been activated, Please check your email"
        redirect_to login_path
      end
      flash[:success] = "Welcome"
      session[:user_id] = authorized_user.id
      redirect_to users_path
    else
      flash[:notice] = "Invalid Username or Password"
      render :login
    end
  end

  def mail_confirm
    user = User.find_by(confirm_code: params[:conf])
    if user == nil
      flash[:notice] = "Sorry that link has expired!"
      redirect_to new_user_path
    elsif !user.confirm_code
      redirect_to login_path
    else
      if user.set_confirm
        flash[:success] = "Account successfully activated, Please login!"
      else
        flash[:error] = "There appears to be a problem, please email advisor"
      end
    end
    render :login
  end

  def forgot_password
    # used only for rendering
  end

  def password
    params.require(:user_auth).permit(:email)
    user = User.find_by(email: params[:user_auth][:email])
    if user and user.confirm_code == nil
      flash[:success] = "Email send successfully, Please Check!"
      code = user.get_reset_code
      ConfMailer.reset_pass(user, code).deliver_now
    else
      flash[:error] = "User does not exist"
    end
    render :login
  end

  def reset_password
    params.require(:code)
    params.permit(:code)
    user = User.find_by(confirm_code: params[:code])
    if user == nil
      flash[:error] = "Sorry the link has expired"
      render :login
    else
      @id = user.id
      render :reset_password
    end
  end

  def reset_password_2
    params.permit(:user_auth)
    params.require(:user_auth).permit(:password, :password_confirmation, :id)
    user = User.find(params[:user_auth][:id])
    user.set_password params[:user_auth][:password]
    render :login
  end

  def show
  end

  def destroy
    @user = User.find(sesson[:user_id])
    @user.destroy
    flash[:success] = "logged out successfully"
    render :landing
  end

  protected

  def param_req
    params.require(:user).permit(:first_name, :email, :password, :last_name, :password_confirmation)
  end

  def params_req2
    params.require(:user_auth).permit(:email, :password)
  end

  def login_req
      if session[:user_id] == nil
          render :landing
      end

  end
end
