class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :diaries, dependent: :destroy

  before_validation :set_activation_token, :set_initial_activation_state, on: :create

  validates :password, length: { minimum: 3 }, if: -> { activation_state == 'active' && (new_record? || changes[:crypted_password]) }
  validates :password, confirmation: true, if: -> { activation_state == 'active' && (new_record? || changes[:crypted_password]) }
  validates :password_confirmation, presence: true, if: -> { activation_state == 'active' && (new_record? || changes[:crypted_password]) }
  validates :name, presence: true, length: { maximum: 255 }, if: -> { activation_state == 'active' && !name.blank? }
  validates :email, presence: true, uniqueness: true
  validates :activation_state, inclusion: { in: %w[active pending] }

  private

  def set_activation_token
    self.activation_token = SecureRandom.hex(10)
    self.activation_token_expires_at = 24.hours.from_now
  end

  def set_initial_activation_state
    self.activation_state ||= 'pending'
  end
end
