class ShortenedUrl < ActiveRecord::Base
  validates :long_url,  :presence => true, :uniqueness => true
  validates :short_url, :presence => true, :uniqueness => true
  validates :user_id,   :presence => true

  has_many(
    :visits,
    class_name: "Visit",
    foreign_key: :shortened_url_id,
    primary_key: :id
  )

  has_many(
    :visitors,
    through: :visits,
    source: :user
  )

  def self.random_code
    random_code = SecureRandom::urlsafe_base64[0..15]
    while ShortenedUrl.exists?(short_url: random_code)
      random_code = SecureRandom::urlsafe_base64[0..15]
    end
    random_code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    short_url = ShortenedUrl.random_code
    ShortenedUrl.create!(
        submitter_id: user.id,
        long_url: long_url,
        short_url: short_url
        )
  end
end
