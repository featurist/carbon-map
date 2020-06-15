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
  has_many :initiatives, foreign_key: 'owner_id', inverse_of: :owner, dependent: :nullify
  has_many :groups_initiatives, through: :groups, source: :initiatives

  attribute :role, :string, default: 'consumer'
end
