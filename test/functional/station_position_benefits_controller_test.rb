require 'test_helper'

class StationPositionBenefitsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:station_position_benefits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create station_position_benefit" do
    assert_difference('StationPositionBenefit.count') do
      post :create, :station_position_benefit => { }
    end

    assert_redirected_to station_position_benefit_path(assigns(:station_position_benefit))
  end

  test "should show station_position_benefit" do
    get :show, :id => station_position_benefits(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => station_position_benefits(:one).to_param
    assert_response :success
  end

  test "should update station_position_benefit" do
    put :update, :id => station_position_benefits(:one).to_param, :station_position_benefit => { }
    assert_redirected_to station_position_benefit_path(assigns(:station_position_benefit))
  end

  test "should destroy station_position_benefit" do
    assert_difference('StationPositionBenefit.count', -1) do
      delete :destroy, :id => station_position_benefits(:one).to_param
    end

    assert_redirected_to station_position_benefits_path
  end
end
