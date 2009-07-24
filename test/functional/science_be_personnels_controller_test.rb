require 'test_helper'

class ScienceBePersonnelsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:science_be_personnels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create science_be_personnel" do
    assert_difference('ScienceBePersonnel.count') do
      post :create, :science_be_personnel => { }
    end

    assert_redirected_to science_be_personnel_path(assigns(:science_be_personnel))
  end

  test "should show science_be_personnel" do
    get :show, :id => science_be_personnels(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => science_be_personnels(:one).to_param
    assert_response :success
  end

  test "should update science_be_personnel" do
    put :update, :id => science_be_personnels(:one).to_param, :science_be_personnel => { }
    assert_redirected_to science_be_personnel_path(assigns(:science_be_personnel))
  end

  test "should destroy science_be_personnel" do
    assert_difference('ScienceBePersonnel.count', -1) do
      delete :destroy, :id => science_be_personnels(:one).to_param
    end

    assert_redirected_to science_be_personnels_path
  end
end
