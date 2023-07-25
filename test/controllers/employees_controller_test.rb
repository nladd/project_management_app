require "test_helper"

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:one)
    @project_manager = project_managers(:one)
    @employee.update(project_manager: @project_manager)

    login_as(@employee)
  end

  test "should get index" do
    get employees_url
    assert_response :success
  end

  test "should show employee" do
    get employee_url(@employee)
    assert_response :success
  end

  test "should update employee" do
    patch employee_url(@employee), params: { employee: { name: "Employee 1",
                                                          email: "employ@example.com",
                                                          password: 'password1',
                                                          title: 'Title',
                                                          work_focus: 'work focus',
                                                          project_manager_id: @project_manager.id  } }
    assert_redirected_to employee_url(@employee)
    assert_equal(@employee.reload.name, 'Employee 1')
    assert_equal(@employee.email, 'employ@example.com')
    assert_equal(@employee.password, 'password1')
    assert_equal(@employee.title, 'Title')
    assert_equal(@employee.work_focus, 'work focus')
  end

end
