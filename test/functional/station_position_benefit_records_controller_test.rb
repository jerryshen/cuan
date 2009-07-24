require 'test_helper'

class StationPositionBenefitRecordsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:station_position_benefit_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create station_position_benefit_record" do
    assert_difference('StationPositionBenefitRecord.count') do
      post :create, :station_position_benefit_record => { }
    end

    assert_redirected_to station_position_benefit_record_path(assigns(:station_position_benefit_record))
  end

  test "should show station_position_benefit_record" do
    get :show, :id => station_position_benefit_records(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => station_position_benefit_records(:one).to_param
    assert_response :success
  end

  test "should update station_position_benefit_record" do
    put :update, :id => station_position_benefit_records(:one).to_param, :station_position_benefit_record => { }
    assert_redirected_to station_position_benefit_record_path(assigns(:station_position_benefit_record))
  end

  test "should destroy station_position_benefit_record" do
    assert_difference('StationPositionBenefitRecord.count', -1) do
      delete :destroy, :id => station_position_benefit_records(:one).to_param
    end

    assert_redirected_to station_position_benefit_records_path
  end
end
