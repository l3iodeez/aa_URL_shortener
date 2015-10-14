class ShortenedUrl
  validates: :long_url, :presence => true, :uniqueness => true
end
