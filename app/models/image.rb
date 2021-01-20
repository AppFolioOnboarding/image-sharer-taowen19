class Image < ApplicationRecord
  acts_as_taggable_on :tags
  include ActiveModel::Validations
  validates_with UrlValidator
end
