# frozen_string_literal: true

class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User', dependent: :destroy
  has_many :websites, class_name: 'GroupWebsite', dependent: :destroy
  has_many :types, class_name: 'GroupGroupType', dependent: :destroy
  has_many :initiatives,
           foreign_key: 'lead_group_id',
           dependent: :destroy,
           inverse_of: :lead_group
end
