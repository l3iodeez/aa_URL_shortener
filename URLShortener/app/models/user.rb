class User < ActiveRecord::Base
  validates :email, :presence => true, :uniqueness => true

  has_many(
    :visits,
    class_name: "Visit",
    foreign_key: :user_id,
    primary_key: :id
  )

end
