require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  setup do
    @valid_image_url = 'https://learn.appfolio.com/apm/www/images/apm-mobile-nav2-logo.png'
    @invalid_image_url = 'https://.com'
  end

  def test_save_image_with_empty_url__failure
    image = Image.new
    refute image.save, 'Saved the image without a url'
  end

  def test_save_image_with_invalid_url__failure
    image = Image.new(url: @invalid_image_url)
    refute image.save, 'Saved the image without a valid url'
  end

  def test_save_image_with_valid_url__success
    image = Image.new(url: @valid_image_url)
    assert image.save, 'Saved the image with a valid url successfully'
  end
end
