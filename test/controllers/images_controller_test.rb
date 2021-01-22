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
    Image.create!(url: @valid_image_url, id: 1, tag_list: %w[tag1])
    Image.create!(url: @valid_image_url, id: 2, tag_list: %w[tag1 tag2])
    get images_url
    assert_response :success
    assert_select 'table>tr:nth-child(1)>td>img' do
      assert_select '[id=?]', '2'
      assert_select '[tags=?]', 'tag1 tag2'
    end
    assert_select 'table>tr:nth-child(2)>td>img' do
      assert_select '[id=?]', '1'
      assert_select '[tags=?]', 'tag1'
    end
  end

  def test_index_with_tag_filter__success
    Image.create!(url: @valid_image_url, id: 1, tag_list: %w[tag1])
    Image.create!(url: @valid_image_url, id: 2, tag_list: %w[tag1 tag2])
    assert_equal Image.tagged_with('tag2').count, 1
    get images_url(tag: 'tag1')
    assert_response :success
    assert_select 'table>tr:nth-child(1)>td>img' do
      assert_select '[id=?]', '2'
      assert_select '[tags=?]', 'tag1 tag2'
    end
    assert_select 'table>tr:nth-child(2)>td>img' do
      assert_select '[id=?]', '1'
      assert_select '[tags=?]', 'tag1'
    end
  end

  def test_index_with_invalid_tag__success
    get images_url(tag: 'tag2')
    assert_response :success
    assert_select 'p', 'There are no images to be displayed.'
    assert_select 'table>tr:count', 0
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
    assert_template :show
  end

  def test_create_with_tags__success
    assert_difference 'Image.count', 1 do
      post images_url, params: { image: { url: @valid_image_url, tags: 'tag1 tag2' } }
    end
    assert_equal %w[tag1 tag2], Image.first.tag_list
    assert_response :success
    assert_template :show
  end

  def test_create__failure
    assert_no_difference 'Image.count' do
      post images_url, params: { image: { url: @invalid_image_url, tags: '' } }
    end
    assert_template :new
    assert_response :success
  end

  def test_show__success
    image = Image.create!(url: @valid_image_url, id: 1, tag_list: %w[tag1 tag2])
    get image_url(image)
    assert_response :success
    assert_select 'div>a:first-child' do
      assert_select "a:match('href',?)", %r{.*/images\?tag=tag1}
    end
    assert_select 'div>a:last-child' do
      assert_select "a:match('href',?)", %r{.*/images\?tag=tag2}
    end

    assert_select 'img' do
      assert_select '[id=?]', '1'
      assert_select '[tags=?]', 'tag1 tag2'
    end
  end

  def test_destroy__success
    Image.create!(url: @valid_image_url, id: 1)
    image_to_delete = Image.create!(url: @valid_image_url, id: 2)
    assert_difference 'Image.count', -1 do
      delete image_url(image_to_delete)
    end
    assert_response :redirect
    assert_redirected_to images_path
    follow_redirect!
    assert_select 'table>tr:nth-child(1)>td>img' do
      assert_select '[id=?]', '1'
    end
  end

  def test_destroy_last_image__success
    image_to_delete = Image.create!(url: @valid_image_url, id: 2)
    assert_difference 'Image.count', -1 do
      delete image_url(image_to_delete)
    end
    assert_response :redirect
    assert_redirected_to images_path
    follow_redirect!
    assert_select 'p', 'There are no images to be displayed.'
  end

  def test_destroy_with_filter__success
    Image.create!(url: @valid_image_url, id: 1, tag_list: %w[tag1])
    image_to_delete = Image.create!(url: @valid_image_url, id: 2, tag_list: %w[tag1])
    assert_difference 'Image.count', -1 do
      delete image_path(image_to_delete), params: { filtered_tag: 'tag1'}
    end

    puts request.params
    assert_response :redirect
    assert_redirected_to images_path(tag: 'tag1')
    follow_redirect!
    assert_select 'p', 'Tag: tag1'
    assert_select 'table>tr:nth-child(1)>td>img' do
      assert_select '[id=?]', '1'
    end
  end
end
