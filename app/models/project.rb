class Project < ApplicationRecord
  default_scope { order(:created_at) }

  belongs_to :user
  has_many :tasks, -> { order(position: :asc) }, dependent: :destroy

  validates :title, length: { maximum: 50 }, presence: true
end
