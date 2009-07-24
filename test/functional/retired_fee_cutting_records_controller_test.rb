require 'test_helper'

class RetiredFeeCuttingRecordsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:retired_fee_cutting_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create retired_fee_cutting_record" do
    assert_difference('RetiredFeeCuttingRecord.count') do
      post :create, :retired_fee_cutting_record => { }
    end

    assert_redirected_to retired_fee_cutting_record_path(assigns(:retired_fee_cutting_record))
  end

  test "should show retired_fee_cutting_record" do
    get :show, :id => retired_fee_cutting_records(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => retired_fee_cutting_records(:one).to_param
    assert_response :success
  end

  test "should update retired_fee_cutting_record" do
    put :update, :id => retired_fee_cutting_records(:one).to_param, :retired_fee_cutting_record => { }
    assert_redirected_to retired_fee_cutting_record_path(assigns(:retired_fee_cutting_record))
  end

  test "should destroy retired_fee_cutting_record" do
    assert_difference('RetiredFeeCuttingRecord.count', -1) do
      delete :destroy, :id => retired_fee_cutting_records(:one).to_param
    end

    assert_redirected_to retired_fee_cutting_records_path
  end
end
