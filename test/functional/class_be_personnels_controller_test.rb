require 'test_helper'

class ClassBePersonnelsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:class_be_personnels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create class_be_personnel" do
    assert_difference('ClassBePersonnel.count') do
      post :create, :class_be_personnel => { }
    end

    assert_redirected_to class_be_personnel_path(assigns(:class_be_personnel))
  end

  test "should show class_be_personnel" do
    get :show, :id => class_be_personnels(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => class_be_personnels(:one).to_param
    assert_response :success
  end

  test "should update class_be_personnel" do
    put :update, :id => class_be_personnels(:one).to_param, :class_be_personnel => { }
    assert_redirected_to class_be_personnel_path(assigns(:class_be_personnel))
  end

  test "should destroy class_be_personnel" do
    assert_difference('ClassBePersonnel.count', -1) do
      delete :destroy, :id => class_be_personnels(:one).to_param
    end

    assert_redirected_to class_be_personnels_path
  end
end
