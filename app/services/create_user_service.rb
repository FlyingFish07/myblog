class CreateUserService
  
  def new_user(email, password, name=nil)
    User.find_or_create_by!(email: email) do |user|
      user.password = password
      user.password_confirmation = password
      user.name = name if not name.nil?
    end
  end

  def new_admin(email, password, name=nil)
    User.find_or_create_by!(email: email) do |user|
        user.password = password
        user.password_confirmation = password
        user.role = :admin
        user.name = name if not name.nil?
      end
  end

  def change_user_info(email, password, name, role)
    user = User.find_by(email: email)
    throw "No User find error!" if user.nil?
    user.password = password if not password.nil?
    user.name = name if not name.nil?
    user.role = role if not role.nil?
    user.save!
  end
end