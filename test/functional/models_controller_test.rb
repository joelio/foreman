require 'test_helper'

class ModelsControllerTest < ActionController::TestCase
  def test_index
    get :index, {}, set_session_user
    assert_template 'index'
  end

  def test_new
    get :new, {}, set_session_user
    assert_template 'new'
  end

  def test_create_invalid
    Model.any_instance.stubs(:valid?).returns(false)
    post :create, {}, set_session_user
    assert_template 'new'
  end

  def test_create_valid
    Model.any_instance.stubs(:valid?).returns(true)
    post :create, {:model => {:name => "test"}}, set_session_user
    assert_redirected_to models_url
  end

  def test_edit
    get :edit, {:id => Model.first}, set_session_user
    assert_template 'edit'
  end

  def test_update_invalid
    Model.any_instance.stubs(:valid?).returns(false)
    put :update, {:id => Model.first}, set_session_user
    assert_template 'edit'
  end

  def test_update_valid
    Model.any_instance.stubs(:valid?).returns(true)
    put :update, {:id => Model.first}, set_session_user
    assert_redirected_to models_url
  end

  def test_destroy
    model = Model.first
    delete :destroy, {:id => model}, set_session_user
    assert_redirected_to models_url
    assert !Model.exists?(model.id)
  end

  def setup_user
    @request.session[:user] = users(:one).id
    users(:one).roles       = [Role.find_by_name('Anonymous'), Role.find_by_name('Viewer')]
  end

  test 'user with viewer rights should fail to edit a model' do
    setup_user
    get :edit, {:id => Model.first.id}
    assert @response.status == '403 Forbidden'
  end

  test 'user with viewer rights should succeed in viewing models' do
    setup_user
    get :index
    assert_response :success
  end
end
