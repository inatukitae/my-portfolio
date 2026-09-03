class Post < ApplicationRecord
  belongs_to :user
  has_one :reflection, dependent: :destroy

  validates :event, presence: true
  validates :emotion, presence: true
  validates :issue, presence: true
end
