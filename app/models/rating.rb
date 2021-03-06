class Rating < ApplicationRecord
  belongs_to :match
  belongs_to :rater, class_name: "User"
  belongs_to :rated, class_name: "User"
  validates :rater_id, presence: true
  validates :rater_id, uniqueness: { scope: :rated_id }
  validates :rated_id, presence: true
  validates :rated_id, uniqueness: { scope: :rater_id }

end
