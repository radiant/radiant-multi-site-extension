class String
  def slugify
    self.strip.downcase.gsub(/[^-a-z0-9~\s\.:;+=_]/, '').gsub(/[\s\.:;=+]+/, '-')
  end
end
