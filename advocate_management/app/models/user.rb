class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :role, presence: true
  validates :advocate_number, presence: true, if: :lawyer?
  has_and_belongs_to_many :states
  has_many :juniors, foreign_key: :user_id, class_name: "User"
  belongs_to :senior, foreign_key: :user_id, class_name: "User", optional: true

  def name
  	"#{first_name} #{last_name}"
  end

  def admin?
  	user_type == AppConstants::USER_TYPE_ADMIN
  end

  def lawyer?
    !admin?
  end

  def senior_lawyer?
    lawyer? && role == AppConstants::ROLE_SENIOR_LAWYER
  end

  def junior_lawyer?
    lawyer? && role == AppConstants::ROLE_JUNIOR_LAWYER
  end

  def check_lawyer_role?
    
  end

end
