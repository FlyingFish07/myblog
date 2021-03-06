class User < ActiveRecord::Base
  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:open_id]


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = ( auth.info && auth.info.email ) || random_email(auth.provider)
      user.password = Devise.friendly_token[0,20]
      user.name = ( auth.info && auth.info.name ) || random_name(auth.provider)   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.openid_data"] && session["devise.openid_data"]["info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  private
    def self.random_email(provider)
      "user#{SecureRandom.hex(10)}@changeme.com"
    end

    def self.random_name(prefix)
      "username#{SecureRandom.hex(10)}"
    end

end
