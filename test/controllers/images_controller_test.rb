require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valid_image_url = 'https://learn.appfolio.com/apm/www/images/apm-mobile-nav2-logo.png'
    @invalid_image_url = 'https://.com'
  end

  teardown do
    Rails.cache.clear
  end

  def test_index__success
    image1 = Image.create!(url: @valid_image_url, id: 1)
    image2 = Image.create!(url: @valid_image_url, id: 2)

    get images_url
    assert_response :success

    assert_select 'table' do
      assert_select 'tr:nth-child(1)' do
        assert_select 'td' do
          assert_select 'img', id: image2.id
        end
      end
      assert_select 'tr:nth-child(2)' do
        assert_select 'td' do
          assert_select 'img', id: image1.id
        end
      end
    end
  end

  def test_new__success
    get new_image_url
    assert_response :success
  end

  def test_create__success
    assert_difference 'Image.count', 1 do
      post images_url, params: { image: { url: @valid_image_url } }
    end

    assert_response :success
  end

  def test_create__failure
    assert_no_difference 'Image.count' do
      post images_url, params: { image: { url: @invalid_image_url } }
    end

    assert_response :success
  end

  def test_show__success
    image = Image.create!(url: @valid_image_url, id: 1)
    get image_url(image)
    assert_response :success
  end
end
