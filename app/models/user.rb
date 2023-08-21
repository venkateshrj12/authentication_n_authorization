class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  
  def jwt_payload
    super
  end

  has_many :companies

  ROLES = %w{super_admin admin manager editor collaborator user}

  # manual role verification
  # def super_admin?
  #   role == super_admin?
  # end
  # def admin?
  #   role == admin?
  # end
  # def manager?
  #   role == manager?
  # end

  # automated role verification using meta programming
  ROLES.each do |role_name|
    define_method "#{role_name}?" do
      role == role_name
    end
  end

  before_create :set_user_role

  def set_user_role
    self.role = 'user'
  end
end
