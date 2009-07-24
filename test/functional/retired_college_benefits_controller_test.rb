require 'test_helper'

class RetiredCollegeBenefitsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:retired_college_benefits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create retired_college_benefit" do
    assert_difference('RetiredCollegeBenefit.count') do
      post :create, :retired_college_benefit => { }
    end

    assert_redirected_to retired_college_benefit_path(assigns(:retired_college_benefit))
  end

  test "should show retired_college_benefit" do
    get :show, :id => retired_college_benefits(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => retired_college_benefits(:one).to_param
    assert_response :success
  end

  test "should update retired_college_benefit" do
    put :update, :id => retired_college_benefits(:one).to_param, :retired_college_benefit => { }
    assert_redirected_to retired_college_benefit_path(assigns(:retired_college_benefit))
  end

  test "should destroy retired_college_benefit" do
    assert_difference('RetiredCollegeBenefit.count', -1) do
      delete :destroy, :id => retired_college_benefits(:one).to_param
    end

    assert_redirected_to retired_college_benefits_path
  end
end
