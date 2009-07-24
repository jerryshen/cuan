require 'test_helper'

class RetiredBasicSalaryRecordsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:retired_basic_salary_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create retired_basic_salary_record" do
    assert_difference('RetiredBasicSalaryRecord.count') do
      post :create, :retired_basic_salary_record => { }
    end

    assert_redirected_to retired_basic_salary_record_path(assigns(:retired_basic_salary_record))
  end

  test "should show retired_basic_salary_record" do
    get :show, :id => retired_basic_salary_records(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => retired_basic_salary_records(:one).to_param
    assert_response :success
  end

  test "should update retired_basic_salary_record" do
    put :update, :id => retired_basic_salary_records(:one).to_param, :retired_basic_salary_record => { }
    assert_redirected_to retired_basic_salary_record_path(assigns(:retired_basic_salary_record))
  end

  test "should destroy retired_basic_salary_record" do
    assert_difference('RetiredBasicSalaryRecord.count', -1) do
      delete :destroy, :id => retired_basic_salary_records(:one).to_param
    end

    assert_redirected_to retired_basic_salary_records_path
  end
end
