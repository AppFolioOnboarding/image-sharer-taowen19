require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  setup do
    @valid_image = images(:valid_image)
    @invalid_image = images(:invalid_image)
  end

  test 'should not save image without url' do
    image = Image.new
    assert_not image.save, 'Saved the image without a url'
  end

  test 'should not save image without a valid url' do
    image = Image.new(url: @invalid_image.url)
    assert_not image.save, 'Saved the image without a valid url'
  end

  test 'should save image with a valid url successfully' do
    image = Image.new(url: @valid_image.url)
    assert image.save, 'Saved the image with a valid url successfully'
  end
end
