class UrlValidator < ActiveModel::Validator
  def validate(image)
    image.errors.add :url, 'invalid url' unless image.url =~ %r{((http(s?):)//.*\.(?:png|jpg|gif|jpeg))}
  end
end
