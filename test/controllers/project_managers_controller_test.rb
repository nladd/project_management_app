require "test_helper"

class ProjectManagersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_manager = project_managers(:one)

    login_as(@project_manager)

  end

  test "should get index" do
    get project_managers_url
    assert_response :success
  end

  test "should get new" do
    get new_project_manager_url
    assert_response :success
  end

  test "should create project_manager" do
    assert_difference("ProjectManager.count") do
      post project_managers_url, params: { project_manager: { name: "Project Manager 1",
                                                              email: "pm@example.com",
                                                              password: 'password1'  } }
    end

    assert_redirected_to project_manager_url(ProjectManager.last)
  end

  test "should show project_manager" do
    get project_manager_url(@project_manager)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_manager_url(@project_manager)
    assert_response :success
  end

  test "should update project_manager" do
    patch project_manager_url(@project_manager), params: { project_manager: { name: "Project Manager 1",
                                                                              email: "pm@example.com",
                                                                              password: 'password1'  } }
    assert_redirected_to project_manager_url(@project_manager)
    assert_equal(@project_manager.reload.name, "Project Manager 1")
    assert_equal(@project_manager.email, "pm@example.com")
    assert_equal(@project_manager.password, 'password1')
  end

  test "should destroy project_manager" do
    assert_difference("ProjectManager.count", -1) do
      delete project_manager_url(@project_manager)
    end

    assert_redirected_to project_managers_url
  end
end
