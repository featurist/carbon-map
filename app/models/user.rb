# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable
  has_many :subscriptions, dependent: :nullify
  has_many :addresses, dependent: :nullify

  def address
    addresses.last
  end

  def active_subscriptions
    subscriptions.where(ended: nil)
  end
end
