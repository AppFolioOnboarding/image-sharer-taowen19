require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  test 'should not save image without url' do
    image = Image.new
    assert_not image.save, 'Saved the image without a url'
  end

  test 'should not save image without a valid url' do
    image = Image.new(url: 'https://.com')
    assert_not image.save, 'Saved the image without a valid url'
    image = Image.new(url: 'data.com/image.gif')
    assert_not image.save, 'Saved the image without a valid url'
  end

  test 'should save image with a valid url successfully' do
    image = Image.new(url: 'https://learn.appfolio.com/apm/www/images/apm-mobile-nav2-logo.png')
    assert image.save, 'Saved the image with a valid url successfully'
  end
end