require 'test_helper'

class AssistantBenefitStandardsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assistant_benefit_standards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assistant_benefit_standard" do
    assert_difference('AssistantBenefitStandard.count') do
      post :create, :assistant_benefit_standard => { }
    end

    assert_redirected_to assistant_benefit_standard_path(assigns(:assistant_benefit_standard))
  end

  test "should show assistant_benefit_standard" do
    get :show, :id => assistant_benefit_standards(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => assistant_benefit_standards(:one).to_param
    assert_response :success
  end

  test "should update assistant_benefit_standard" do
    put :update, :id => assistant_benefit_standards(:one).to_param, :assistant_benefit_standard => { }
    assert_redirected_to assistant_benefit_standard_path(assigns(:assistant_benefit_standard))
  end

  test "should destroy assistant_benefit_standard" do
    assert_difference('AssistantBenefitStandard.count', -1) do
      delete :destroy, :id => assistant_benefit_standards(:one).to_param
    end

    assert_redirected_to assistant_benefit_standards_path
  end
end
