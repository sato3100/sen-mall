class Report < ApplicationRecord
  belongs_to :reporter, class_name: "User", optional: true
  belongs_to :reported_user, class_name: "User", optional: true
  belongs_to :item, optional: true
  belongs_to :review, optional: true
end
