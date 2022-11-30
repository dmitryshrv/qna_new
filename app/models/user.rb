class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_one :reward, dependent: nil

  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
