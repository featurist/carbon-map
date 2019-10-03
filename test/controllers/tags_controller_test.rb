# frozen_string_literal: true

require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tag = tags(:one)
  end

  test 'should get index' do
    sign_in_as :georgie
    get tags_url
    assert_response :success
  end

  test 'should get new' do
    sign_in_as :georgie
    get new_tag_url
    assert_response :success
  end

  test 'should create tag' do
    sign_in_as :georgie
    assert_difference('Tag.count') do
      post tags_url, params: { tag: { name: @tag.name } }
    end

    assert_redirected_to tags_url
  end

  test 'should show tag' do
    sign_in_as :georgie
    get tag_url(@tag)
    assert_response :success
  end

  test 'should get edit' do
    sign_in_as :georgie
    get edit_tag_url(@tag)
    assert_response :success
  end

  test 'should update tag' do
    sign_in_as :georgie
    patch tag_url(@tag), params: { tag: { name: @tag.name } }
    assert_redirected_to tag_url(@tag)
  end

  test 'should destroy tag' do
    sign_in_as :georgie
    assert_difference('Tag.count', -1) do
      delete tag_url(@tag)
    end

    assert_redirected_to tags_url
  end
end
