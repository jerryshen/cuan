require 'test_helper'

class ClassBeEdusControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:class_be_edus)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create class_be_edu" do
    assert_difference('ClassBeEdu.count') do
      post :create, :class_be_edu => { }
    end

    assert_redirected_to class_be_edu_path(assigns(:class_be_edu))
  end

  test "should show class_be_edu" do
    get :show, :id => class_be_edus(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => class_be_edus(:one).to_param
    assert_response :success
  end

  test "should update class_be_edu" do
    put :update, :id => class_be_edus(:one).to_param, :class_be_edu => { }
    assert_redirected_to class_be_edu_path(assigns(:class_be_edu))
  end

  test "should destroy class_be_edu" do
    assert_difference('ClassBeEdu.count', -1) do
      delete :destroy, :id => class_be_edus(:one).to_param
    end

    assert_redirected_to class_be_edus_path
  end
end
