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
    Image.create!(url: @valid_image_url, id: 1, tag_list: '')
    Image.create!(url: @valid_image_url, id: 2, tag_list: 'tag1 tag2')

    get images_url
    assert_response :success

    assert_select 'table' do
      assert_select 'tr:nth-child(1)' do
        assert_select 'td' do
          assert_select 'img' do
            assert_select '[id=?]', '2'
            assert_select '[tags=?]', 'tag1 tag2'
          end
        end
      end
      assert_select 'tr:nth-child(2)' do
        assert_select 'td' do
          assert_select 'img' do
            assert_select '[id=?]', '1'
            assert_select '[tags=?]', ''
          end
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
      post images_url, params: { image: { url: @valid_image_url, tags: '' } }
    end

    assert_equal %w[], Image.first.tag_list
    assert_response :success
  end

  def test_create_with_tags__success
    assert_difference 'Image.count', 1 do
      post images_url, params: { image: { url: @valid_image_url, tags: 'tag1 tag2' } }
    end

    assert_equal %w[tag1 tag2], Image.first.tag_list
    assert_response :success
  end

  def test_create__failure
    assert_no_difference 'Image.count' do
      post images_url, params: { image: { url: @invalid_image_url, tags: '' } }
    end

    assert_response :success
  end

  def test_show__success
    image = Image.create!(url: @valid_image_url, id: 1, tag_list: 'tag1 tag2')
    get image_url(image)
    assert_response :success

    assert_select 'h1', 'tag1 tag2'

    assert_select 'img' do
      assert_select '[id=?]', '1'
      assert_select '[tags=?]', 'tag1 tag2'
    end
  end
end
