class TagTopic < ActiveRecord::Base
  validates :topic_name, presence: true

  has_many(
    :taggings,
    class_name:  'Tagging',
    foreign_key: :tag_topic_id,
    primary_key: :id
  )
  has_many(
    :shortened_urls,
    through: :taggings,
    source:  :shortened_url
  )
end
