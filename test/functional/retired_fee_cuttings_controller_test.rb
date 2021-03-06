require 'test_helper'

class RetiredFeeCuttingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:retired_fee_cuttings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create retired_fee_cutting" do
    assert_difference('RetiredFeeCutting.count') do
      post :create, :retired_fee_cutting => { }
    end

    assert_redirected_to retired_fee_cutting_path(assigns(:retired_fee_cutting))
  end

  test "should show retired_fee_cutting" do
    get :show, :id => retired_fee_cuttings(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => retired_fee_cuttings(:one).to_param
    assert_response :success
  end

  test "should update retired_fee_cutting" do
    put :update, :id => retired_fee_cuttings(:one).to_param, :retired_fee_cutting => { }
    assert_redirected_to retired_fee_cutting_path(assigns(:retired_fee_cutting))
  end

  test "should destroy retired_fee_cutting" do
    assert_difference('RetiredFeeCutting.count', -1) do
      delete :destroy, :id => retired_fee_cuttings(:one).to_param
    end

    assert_redirected_to retired_fee_cuttings_path
  end
end
