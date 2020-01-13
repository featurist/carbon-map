# frozen_string_literal: true

class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User', dependent: :destroy
  has_many :websites, class_name: 'GroupWebsite', dependent: :destroy
  has_many :types, class_name: 'GroupGroupType', dependent: :destroy
  has_many :initiatives,
           foreign_key: 'lead_group_id',
           dependent: :destroy,
           inverse_of: :lead_group
  accepts_nested_attributes_for :websites, allow_destroy: true, reject_if: :website_empty?
  validates :name,
            :abbreviation,
            :contact_name,
            :contact_email,
            :contact_phone,
            presence: true

  def website_empty?(attributes)
    attributes['website'].blank?
  end

  def empty?
    attributes.each { |_, value| return false if value.present? }
    true
  end
end
