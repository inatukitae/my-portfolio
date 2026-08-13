class Post < ApplicationRecord
  belongs_to :user

  validates :event, presence: true
  validates :emotion, presence: true
  validates :issue, presence: true
end