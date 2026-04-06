class User < ApplicationRecord
   has_many :aml_alerts_reviewed, class_name: "AmlAlert", foreign_key: "reviewed_by_id", dependent: :nullify
end
