class ShortenedUrl < ActiveRecord::Base
  validate  :submission_rate_limit, :non_premium_submission_limit
  validates :long_url,  :presence => true, length: { maximum: 1024 }
  validates :short_url, :presence => true, :uniqueness => true
  validates :submitter_id,   :presence => true

  has_many(
    :visits,
    class_name: "Visit",
    foreign_key: :shortened_url_id,
    primary_key: :id
  )

  has_many(
    :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :visitor
  )

  has_many(
    :taggings,
    class_name:  'Tagging',
    foreign_key: :shortened_url_id,
    primary_key: :id
  )

  has_many(
    :tag_topics,
    through: :taggings,
    source: :tag_topic
  )
  belongs_to(
    :submitter,
    class_name: 'User',
    foreign_key: :submitter_id,
    primary_key: :id
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

  def self.create_for_user_and_long_url(user, long_url)
    short_url = ShortenedUrl.random_code
    ShortenedUrl.create(
        submitter_id: user.id,
        long_url: long_url,
        short_url: short_url
        )
  end

  def self.num_recent_submissions(user)
    where('submitter_id = ? AND created_at > ?', user.id, 5.minutes.ago).count
  end

  def num_uniques
    visitors.count
    # visits.select(:user_id).distinct.count
  end

  def num_clicks
    visits.count
  end

  def num_recent_uniques
    visits.select(:user_id).where(
      "created_at > ?", 10.minutes.ago).distinct.count
  end

  private
    def submission_rate_limit
      if ShortenedUrl.num_recent_submissions(submitter) >= 5
        errors[:base] << "You have submitted too many URLs recently."
      end

      nil
    end

    def non_premium_submission_limit
      unless submitter.premium?
        error_str = "You have reached the non-premium submission limit."
        errors[:base] << error_str if submitter.submissions.count >= 5
      end

      nil
    end
end
