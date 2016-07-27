class Admin::UsersController < Admin::BaseController
  # before_action :authenticate_user! 已配置在base controller中
  after_action :verify_authorized #用于保证某个方法一定是经过授权的，否则将抛异常

  def index
    @users = User.all
    authorize User
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def edit_for_omniauth
     @user = User.find(params[:id])
     authorize @user
  end

  def update_for_omniauth
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      redirect_to admin_root_path, :notice => "帐号资料更新成功。"
    else
      redirect_to admin_root_path, :alert => "帐号资料更新失败。"
    end
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      redirect_to admin_root_path, :notice => "帐号资料更新成功。"
    else
      redirect_to admin_root_path, :alert => "帐号资料更新失败。"
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to admin_root_path, :notice => "帐号删除成功。"
  end

  private

  def secure_params
    params.require(:user).permit(:role, :name)
  end

end
