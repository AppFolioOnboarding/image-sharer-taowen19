require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  setup do
    @valid_image = images(:valid_image)
    @invalid_image = images(:invalid_image)
  end

  def test_save_image_with_empty_url__failure
    image = Image.new
    refute image.save, 'Saved the image without a url'
  end

  def test_save_image_with_invalid_url__failure
    image = Image.new(url: @invalid_image.url)
    refute image.save, 'Saved the image without a valid url'
  end

  def test_save_image_with_valid_url__success
    image = Image.new(url: @valid_image.url)
    assert image.save, 'Saved the image with a valid url successfully'
  end
end
