require 'test_helper'

class RetiredCollegeBeRecordsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:retired_college_be_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create retired_college_be_record" do
    assert_difference('RetiredCollegeBeRecord.count') do
      post :create, :retired_college_be_record => { }
    end

    assert_redirected_to retired_college_be_record_path(assigns(:retired_college_be_record))
  end

  test "should show retired_college_be_record" do
    get :show, :id => retired_college_be_records(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => retired_college_be_records(:one).to_param
    assert_response :success
  end

  test "should update retired_college_be_record" do
    put :update, :id => retired_college_be_records(:one).to_param, :retired_college_be_record => { }
    assert_redirected_to retired_college_be_record_path(assigns(:retired_college_be_record))
  end

  test "should destroy retired_college_be_record" do
    assert_difference('RetiredCollegeBeRecord.count', -1) do
      delete :destroy, :id => retired_college_be_records(:one).to_param
    end

    assert_redirected_to retired_college_be_records_path
  end
end
