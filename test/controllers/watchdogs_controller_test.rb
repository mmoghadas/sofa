require 'test_helper'

class WatchdogsControllerTest < ActionController::TestCase
  setup do
    @watchdog = watchdogs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:watchdogs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create watchdog" do
    assert_difference('Watchdog.count') do
      post :create, watchdog: { name: @watchdog.name, state: @watchdog.state }
    end

    assert_redirected_to watchdog_path(assigns(:watchdog))
  end

  test "should show watchdog" do
    get :show, id: @watchdog
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @watchdog
    assert_response :success
  end

  test "should update watchdog" do
    patch :update, id: @watchdog, watchdog: { name: @watchdog.name, state: @watchdog.state }
    assert_redirected_to watchdog_path(assigns(:watchdog))
  end

  test "should destroy watchdog" do
    assert_difference('Watchdog.count', -1) do
      delete :destroy, id: @watchdog
    end

    assert_redirected_to watchdogs_path
  end
end
