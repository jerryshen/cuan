require 'test_helper'

class AssistantsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assistants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assistant" do
    assert_difference('Assistant.count') do
      post :create, :assistant => { }
    end

    assert_redirected_to assistant_path(assigns(:assistant))
  end

  test "should show assistant" do
    get :show, :id => assistants(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => assistants(:one).to_param
    assert_response :success
  end

  test "should update assistant" do
    put :update, :id => assistants(:one).to_param, :assistant => { }
    assert_redirected_to assistant_path(assigns(:assistant))
  end

  test "should destroy assistant" do
    assert_difference('Assistant.count', -1) do
      delete :destroy, :id => assistants(:one).to_param
    end

    assert_redirected_to assistants_path
  end
end
