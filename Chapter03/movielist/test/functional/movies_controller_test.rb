require File.dirname(__FILE__) + '/../test_helper'

class MoviesControllerTest < ActionController::TestCase
  def test_unauthorized_access_should_be_redirected
    get :new
    assert_redirected_to :new_session_path
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:movies)
  end

  def test_should_get_new
    login_as :quentin
    get :new
    assert_response :success
  end
  
  def test_should_require_administrator
    # we raise an exception here to prevent any further processing
    MoviesController.any_instance.expects(:require_admin).raises(StandardError)
    assert_raises(StandardError) do
      get :new
    end
  end

  def test_should_create_movie
    login_as :quentin
    assert_difference('Movie.count') do
      post :create, :movie => {:title => 'Daredevil'}
    end

    assert_redirected_to movie_path(assigns(:movie))
  end
  
  def test_failed_create_should_rerender_form
    login_as :quentin
    post :create, :movie => {}
    assert_template 'new'
  end

  def test_should_show_movie
    get :show, :id => movies(:one).id
    assert_response :success
  end

  def test_should_get_edit
    login_as :quentin
    get :edit, :id => movies(:one).id
    assert_response :success
  end

  def test_should_redirect_after_good_update
    login_as :quentin
    put :update, :id => movies(:one).id, :movie => { :title => 'Elektra' }
    assert_redirected_to movie_path(assigns(:movie))
  end

  def test_failed_update_should_rerender_form
    login_as :quentin
    post :update, :id => movies(:one).id, :movie => {:title => nil}
    assert_template 'edit'
  end

  def test_should_destroy_movie
    login_as :quentin
    assert_difference('Movie.count', -1) do
      delete :destroy, :id => movies(:one).id
    end

    assert_redirected_to movies_path
  end
  
  def test_uploading_data_should_create_movie_image
    Movie.any_instance.expects(:create_image).returns(true)
    login_as :quentin
    post :update, :id => movies(:one).id, :movie => {:uploaded_data => uploaded_jpg("#{RAILS_ROOT}/test/fixtures/files/large-1.jpg")}
  end
end
