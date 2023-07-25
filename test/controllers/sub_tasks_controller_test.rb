require "test_helper"

class SubTasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sub_task = sub_tasks(:one)
    @task = tasks(:one)
    @task_status = task_statuses(:one)
    @project_manager = project_managers(:one)
    @employee = employees(:one)

    @employee.update(project_manager: @project_manager)
    @task.update(project: projects(:one), employee: @employee, project_manager: @project_manager, task_status: @task_status)
    @sub_task.update(task_status: @task_status,
                 employee: @employee,
                 task: @task)

  end

  class ProjectManagerTests < SubTasksControllerTest
    setup do
      login_as(@project_manager)
    end

    test "project manager should be able to create a sub task" do
      assert_difference("SubTask.count") do
        post sub_tasks_url, params: { sub_task: { title: 'Test SubTask',
                                          description: 'SubTest task description',
                                          work_focus: 'focus',
                                          task_status_id: @task_status.id,
                                          due_date: Date.today,
                                          employee_id: @employee.id,
                                          task_id: @task.id } }
      end
  
      assert_redirected_to sub_task_url(SubTask.last)
    end

    test "should get index" do
      get sub_tasks_url
      assert_response :success
    end
  
    test "should get new" do
      get new_sub_task_url
      assert_response :success
    end
  
    test "should show sub task" do
      get sub_task_url(@sub_task)
      assert_response :success
    end
  
    test "should get edit" do
      get edit_sub_task_url(@sub_task)
      assert_response :success
    end
  
    test "should update sub task" do
      new_description = 'new description'
      patch sub_task_url(@sub_task), params: { sub_task: { description: new_description  } }
      assert_redirected_to sub_task_url(@sub_task)
      assert_equal(@sub_task.reload.description, new_description)
    end
  
    test "should destroy sub task" do
      assert_difference("SubTask.count", -1) do
        delete sub_task_url(@sub_task)
      end
  
      assert_redirected_to sub_tasks_url
    end

  end # end ProjectManagerTests
  
  class EmployeeTests < SubTasksControllerTest
    setup do
      login_as(@employee)
    end

    test "employee should not be able to create a sub task" do
      assert_no_difference("SubTask.count") do
        post sub_tasks_url, headers: { referer: projects_url }, params: { task: { title: 'Test Task',
                                                                      description: 'Test task description',
                                                                      work_focus: 'focus',
                                                                      task_status_id: @task_status.id,
                                                                      due_date: Date.today,
                                                                      employee_id: @employee.id,
                                                                      task_id: @task.id } }
                                          
      end
  
      assert_redirected_to projects_path
    end

    test "should get index" do
      get sub_tasks_url
      assert_response :success
    end
  
    test "should forbid new" do
      get new_sub_task_url, headers: { referer: projects_url }
      assert_redirected_to projects_path
    end
  
    test "should show sub_task" do
      get sub_task_url(@sub_task)
      assert_response :success
    end
  
    test "should get edit" do
      get edit_sub_task_url(@sub_task), headers: { referer: projects_url }
      assert_response :success
    end
  
    test "should update sub_task" do
      due_date = Date.today + 5.days
      patch sub_task_url(@sub_task), params: { sub_task: { due_date: due_date } }
      assert_redirected_to sub_task_url(@sub_task)
      assert_equal(@sub_task.reload.due_date, due_date)
    end
  
    test "should forbid destroying a sub_task" do
      assert_no_difference("SubTask.count") do
        delete sub_task_url(@sub_task), headers: { referer: projects_url }
      end
  
      assert_redirected_to projects_url
    end

  end # end EmployeeTests

end
