require 'test_helper'

URL = 'https://learn.appfolio.com/apm/www/images/apm-mobile-nav2-logo.png'.freeze

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = images(:one)
  end

  test 'should get index' do
    get images_url
    assert_response :success
  end

  test 'should get new' do
    get new_image_url
    assert_response :success
  end

  test 'should create image' do
    assert_difference('Image.count') do
      post images_url, params: { image: { url: URL } }
    end

    assert_response :success
  end

  test 'should not create image' do
    assert_no_difference('Image.count') do
      post images_url, params: { image: { url: '' } }
    end

    assert_response :success
  end

  test 'should show image' do
    get image_url(@image)
    assert_response :success
  end
end
