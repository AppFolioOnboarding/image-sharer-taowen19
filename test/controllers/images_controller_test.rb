require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valid_image = images(:valid_image)
    @invalid_image = images(:invalid_image)
  end

  teardown do
    Rails.cache.clear
  end

  def test_index__success
    get images_url
    assert_response :success
  end

  def test_new__success
    get new_image_url
    assert_response :success
  end

  def test_create__success
    assert_difference('Image.count', 1) do
      post images_url, params: { image: { url: @valid_image.url } }
    end

    assert_response :success
  end

  def test_create__failure
    assert_no_difference('Image.count') do
      post images_url, params: { image: { url: @invalid_image.url } }
    end

    assert_response :success
  end

  def test_show__success
    get image_url(@valid_image)
    assert_response :success
  end
end
