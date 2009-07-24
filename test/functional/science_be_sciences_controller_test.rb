require 'test_helper'

class ScienceBeSciencesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:science_be_sciences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create science_be_science" do
    assert_difference('ScienceBeScience.count') do
      post :create, :science_be_science => { }
    end

    assert_redirected_to science_be_science_path(assigns(:science_be_science))
  end

  test "should show science_be_science" do
    get :show, :id => science_be_sciences(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => science_be_sciences(:one).to_param
    assert_response :success
  end

  test "should update science_be_science" do
    put :update, :id => science_be_sciences(:one).to_param, :science_be_science => { }
    assert_redirected_to science_be_science_path(assigns(:science_be_science))
  end

  test "should destroy science_be_science" do
    assert_difference('ScienceBeScience.count', -1) do
      delete :destroy, :id => science_be_sciences(:one).to_param
    end

    assert_redirected_to science_be_sciences_path
  end
end
