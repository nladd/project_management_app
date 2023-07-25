require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:one)
    @project = projects(:one)
    @task_status = task_statuses(:one)
    @project_manager = project_managers(:one)
    @employee = employees(:one)

    @employee.update(project_manager: @project_manager)
    @task.update(task_status: @task_status,
                 project_manager: @project_manager,
                 employee: @employee,
                 project: @project)
  end

  class ProjectManagerTests < TasksControllerTest
    setup do
      login_as(@project_manager)
    end

    test "project manager should be able to create a task" do
      assert_difference("Task.count") do
        post tasks_url, params: { task: { title: 'Test Task',
                                          description: 'Test task description',
                                          work_focus: 'focus',
                                          task_status_id: @task_status.id,
                                          due_date: Date.today,
                                          project_manager_id: @project_manager.id,
                                          employee_id: @employee.id,
                                          project_id: @project.id } }
      end
  
      assert_redirected_to task_url(Task.last)
    end

    test "should get index" do
      get tasks_url
      assert_response :success
    end
  
    test "should get new" do
      get new_task_url
      assert_response :success
    end
  
    test "should show task" do
      get task_url(@task)
      assert_response :success
    end
  
    test "should get edit" do
      get edit_task_url(@task)
      assert_response :success
    end
  
    test "should update task" do
      new_description = 'new description'
      patch task_url(@task), params: { task: { description: new_description  } }
      assert_redirected_to task_url(@task)
      assert_equal(@task.reload.description, new_description)
    end
  
    test "should destroy task" do
      assert_difference("Task.count", -1) do
        delete task_url(@task)
      end
  
      assert_redirected_to tasks_url
    end

  end # end ProjectManagerTests
  
  class EmployeeTests < TasksControllerTest
    setup do
      login_as(@employee)
    end

    test "employee should not be able to create a task" do
      assert_no_difference("Task.count") do
        post tasks_url, headers: { referer: projects_url }, params: { task: { title: 'Test Task',
                                                                      description: 'Test task description',
                                                                      work_focus: 'focus',
                                                                      task_status_id: @task_status.id,
                                                                      due_date: Date.today,
                                                                      project_manager_id: @project_manager.id,
                                                                      employee_id: @employee.id,
                                                                      project_id: @project.id } }
                                          
      end
  
      assert_redirected_to projects_path
    end

    test "should get index" do
      get tasks_url
      assert_response :success
    end
  
    test "should forbid new" do
      get new_task_url, headers: { referer: projects_url }
      assert_redirected_to projects_path
    end
  
    test "should show task" do
      get task_url(@task)
      assert_response :success
    end
  
    test "should get edit" do
      get edit_task_url(@task), headers: { referer: projects_url }
      assert_response :success
    end
  
    test "should update task" do
      due_date = Date.today + 5.days
      patch task_url(@task), params: { task: { due_date: due_date } }
      assert_redirected_to task_url(@task)
      assert_equal(@task.reload.due_date, due_date)
    end
  
    test "should forbid destroying a task" do
      assert_no_difference("Task.count") do
        delete task_url(@task), headers: { referer: projects_url }
      end
  
      assert_redirected_to projects_url
    end

  end # end EmployeeTests

  
end
