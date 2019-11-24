# frozen_string_literal: true

class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User', dependent: :destroy
  has_many :websites, class_name: 'GroupWebsite', dependent: :destroy
  has_many :types, class_name: 'GroupGroupType', dependent: :destroy
  has_many :initiatives,
           foreign_key: 'lead_group_id',
           dependent: :destroy,
           inverse_of: :lead_group
  validates :consent_to_share, acceptance: true
  accepts_nested_attributes_for :websites, allow_destroy: true

  def empty?
    attributes.each { |_, value| return false if value.present? }
    true
  end
end
