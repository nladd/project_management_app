require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest

    class ProjectManagerTests < SessionsControllerTest
        setup do
            @project_manager = project_managers(:one)
            @project_manager.update(login_key: nil)
        end

        test "a project manager can login with valid credentials" do
            assert_nil(@project_manager.login_key)
            post login_submit_path, params: {email: @project_manager.email, password: @project_manager.password, role: ProjectManager.name}
            assert_redirected_to projects_path
            assert_not_nil(@project_manager.reload.login_key)
        end

        test "a project manager cannot login with invalid password" do
            assert_nil(@project_manager.login_key)
            post login_submit_path, params: {email: @project_manager.email, password: "#{@project_manager.password}invalid", role: ProjectManager.name}
            assert_redirected_to root_path
            assert_nil(@project_manager.reload.login_key)
        end

        test "a project manager cannot login with invalid email" do
            assert_nil(@project_manager.login_key)
            post login_submit_path, params: {email: "#{@project_manager.email}invalid", password: @project_manager.password, role: ProjectManager.name}
            assert_redirected_to root_path
            assert_nil(@project_manager.reload.login_key)
        end

        test "a project manager cannot login with invalid role" do
            assert_nil(@project_manager.login_key)
            post login_submit_path, params: {email: "#{@project_manager.email}inalid", password: @project_manager.password, role: "InvalidRole"}
            assert_redirected_to root_path
            assert_nil(@project_manager.reload.login_key)
        end

        test "logging out invalidates the login key" do
            login_as(@project_manager)
            get logout_path
            assert_nil(@project_manager.reload.login_key)
            assert_redirected_to root_path

            get projects_path
            assert_redirected_to root_path
        end

        test "a project manager can obtain a valid login key from the API" do
            assert_nil(@project_manager.login_key)
            post login_submit_path(format: :json), params: {email: @project_manager.email, password: @project_manager.password, role: ProjectManager.name}
            assert_not_nil(@project_manager.reload.login_key)
            assert_equal(response.body, {login_key: @project_manager.login_key}.to_json)
        end

        test "logging out via the API invalidates the login key" do
            post login_submit_path(format: :json), params: {email: @project_manager.email, password: @project_manager.password, role: ProjectManager.name}
            assert_not_nil(@project_manager.reload.login_key)
            assert_equal(response.body, {login_key: @project_manager.login_key}.to_json)

            get logout_path(format: :json), headers: {'Authorization' => "Bearer #{@project_manager.login_key}"}
            assert_nil(@project_manager.reload.login_key)
            assert_equal(response.body, {message: "Logout successful"}.to_json)
        end

    end

    class EmployeeTests < SessionsControllerTest
        setup do
            @employee = employees(:one)
            @employee.update(login_key: nil, project_manager: project_managers(:one))
        end

        test "an employee can login with valid credentials" do
            assert_nil(@employee.login_key)
            post login_submit_path, params: {email: @employee.email, password: @employee.password, role: Employee.name}
            assert_redirected_to projects_path
            assert_not_nil(@employee.reload.login_key)
        end

        test "an employee cannot login with invalid password" do
            assert_nil(@employee.login_key)
            post login_submit_path, params: {email: @employee.email, password: "#{@employee.password}invalid", role: ProjectManager.name}
            assert_redirected_to root_path
            assert_nil(@employee.reload.login_key)
        end

        test "an employee cannot login with invalid email" do
            assert_nil(@employee.login_key)
            post login_submit_path, params: {email: "#{@employee.email}invalid", password: @employee.password, role: ProjectManager.name}
            assert_redirected_to root_path
            assert_nil(@employee.reload.login_key)
        end

        test "an employee cannot login with invalid role" do
            assert_nil(@employee.login_key)
            post login_submit_path, params: {email: "#{@employee.email}inalid", password: @employee.password, role: "InvalidRole"}
            assert_redirected_to root_path
            assert_nil(@employee.reload.login_key)
        end

        test "logging out invalidates the login key" do
            login_as(@employee)
            get logout_path
            assert_nil(@employee.reload.login_key)
            assert_redirected_to root_path

            get projects_path
            assert_redirected_to root_path
        end

        test "an employee can obtain a valid login key from the API" do
            assert_nil(@employee.login_key)
            post login_submit_path(format: :json), params: {email: @employee.email, password: @employee.password, role: Employee.name}
            assert_not_nil(@employee.reload.login_key)
            assert_equal(response.body, {login_key: @employee.login_key}.to_json)
        end

        test "logging out via the API invalidates the login key" do
            post login_submit_path(format: :json), params: {email: @employee.email, password: @employee.password, role: Employee.name}
            assert_not_nil(@employee.reload.login_key)
            assert_equal(response.body, {login_key: @employee.login_key}.to_json)

            get logout_path(format: :json), headers: {'Authorization' => "Bearer #{@employee.login_key}"}
            assert_nil(@employee.reload.login_key)
            assert_equal(response.body, {message: "Logout successful"}.to_json)
        end

    end

end