class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :role, presence: true
  validates :advocate_number, presence: true, if: :lawyer?
  has_and_belongs_to_many :states
  has_many :juniors, foreign_key: :user_id, class_name: "User"
  has_many :cases, foreign_key: :advocate_id, class_name: "Case"
  belongs_to :senior, foreign_key: :user_id, class_name: "User", optional: true
  scope :all_juniors, ->(user_id=nil){where(user_type: AppConstants::USER_TYPE_LAWYER, role: AppConstants::ROLE_JUNIOR_LAWYER, user_id: user_id)}
  before_validation(on: :create) do
    set_default_pwd
  end
  after_create :send_default_pwd

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

  def self.encrypt_data(data)
    encrypted_data = data
    aes = OpenSSL::Cipher::Cipher.new("aes-128-ecb")
    aes.encrypt
    aes.key = "thKq6NpioHozoCLn"
    final_data = aes.update(encrypted_data.to_s) + aes.final
    final_data = Base64.encode64(final_data).gsub("\n", "")
    return final_data
  end
  
  def self.decrypt_data(data)
    decrypted_data = Base64.decode64(data)
    aes = OpenSSL::Cipher::Cipher.new("aes-128-ecb")
    aes.decrypt
    aes.key = "thKq6NpioHozoCLn"
    final_data = aes.update(decrypted_data.to_s) + aes.final
    return final_data
  end

  def contact_details
    "<i class='fas fa-envelope'></i> #{email}<br><i class='fas fa-mobile'></i> #{mobile_number}".html_safe
  end
  
  private
    def set_default_pwd
      if self.is_auto_pwd & self.new_record?
        def_pwd = Devise.friendly_token[0,14]
        encrypted_pwd = User.encrypt_data(def_pwd)
        self.enc_def_pwd = encrypted_pwd
        self.password = def_pwd
        self.password_confirmation = def_pwd
      end
    end
    def send_default_pwd
      ApplicationMailer.send_default_pwd(self).deliver_now if self.is_auto_pwd
    end
end
