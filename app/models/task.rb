class Task < ApplicationRecord
  belongs_to :project
  acts_as_list scope: :project

  validates :title, length: { maximum: 100 }, presence: true
end
