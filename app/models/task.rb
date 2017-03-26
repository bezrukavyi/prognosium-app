class Task < ApplicationRecord
  belongs_to :project
  has_one :forecast, dependent: :destroy

  acts_as_list scope: :project

  accepts_nested_attributes_for :forecast

  validates :title, length: { maximum: 100 }, presence: true
end
