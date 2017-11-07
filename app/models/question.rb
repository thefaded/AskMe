class Question < ApplicationRecord
  belongs_to :user
  validates :text, presence: true
  validates :answer, presence: true, on: :update
end
