class Project < ApplicationRecord
  default_scope { order(:created_at) }

  belongs_to :user
  validates :title, length: { maximum: 50 }, presence: true
end
