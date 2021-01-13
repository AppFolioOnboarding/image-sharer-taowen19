class Image < ApplicationRecord
  include ActiveModel::Validations
  validates_with UrlValidator
end
