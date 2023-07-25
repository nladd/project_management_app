require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:one)
    @project_manager = project_managers(:one)

    @project.update(project_manager: @project_manager)

    login_as(@project_manager)
    @project_manager.reload
  end

  test "should get index" do
    get projects_url
    assert_response :success
  end

  test "should get new" do
    get new_project_url
    assert_response :success
  end

  test "should create project" do
    assert_difference("Project.count") do
      post projects_url, params: { project: { title: "Project Title",
                                              description: "Project description",
                                              due_date: Date.today + 30.days,
                                              project_manager_id: @project_manager.id  } }
    end

    assert_redirected_to project_url(Project.last)
  end

  test "should show project" do
    get project_url(@project)
    assert_response :success
  end

  test "API should return details of project" do
    get project_url(@project, format: :json), headers: {'Authorization' => "Bearer #{@project_manager.login_key}"}
    assert_response :success
    resp = JSON.parse(response.body)
    JSON.parse(@project.to_json).each do |k, v|
      assert_equal(v, resp[k])
    end
  end

  test "should get edit" do
    get edit_project_url(@project)
    assert_response :success
  end

  test "should update project" do
    patch project_url(@project), params: { project: { title: "Project Title update",
                                                      description: "Project description update",
                                                      due_date: Date.today + 35.days,
                                                      project_manager_id: @project_manager.id } }
    assert_redirected_to project_url(@project)
    assert_equal(@project.reload.title, "Project Title update")
    assert_equal(@project.description, "Project description update")
    assert_equal(@project.due_date, Date.today + 35.days)
  end

  test "should destroy project" do
    assert_difference("Project.count", -1) do
      delete project_url(@project)
    end

    assert_redirected_to projects_url
  end
end
