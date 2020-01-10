# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :confirmable,
         :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable
  has_many :groups,
           dependent: :nullify, foreign_key: 'owner_id', inverse_of: :owner
  has_many :initiatives, through: :groups

  attribute :role, :string, default: 'consumer'
end
