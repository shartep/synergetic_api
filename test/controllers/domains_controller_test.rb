require 'test_helper'

class DomainsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:domains)
  end

  test "shouldn't create domain http://ya.ru, request without any credentials" do
    @domain = domains(:two)

    assert_no_difference('Domain.count') do
      post :create, domain: { url: @domain.url }
    end

    assert_response 401
  end

  test "shouldn't create domain http://ya.ru, request with admin3 credentials" do
    @domain = domains(:two)

    assert_no_difference('Domain.count') do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin3', '')
      post :create, domain: { url: @domain.url }
    end

    assert_response 422
  end

  test "should create domain https://mail.ru, request with admin3 credentials" do
    @domain = domains(:one)

    assert_difference('Domain.count') do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin3', '')
      post :create, domain: { url: @domain.url }
    end

    assert_response 201
  end
end
