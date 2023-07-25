ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "sidekiq/testing"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  ['Not started', 'Working', 'Needs review', 'Done', 'Late'].each do |task_status|
    TaskStatus.create(name: task_status)
  end

  Object.send(:remove_const, :TaskStatus)
  load 'app/models/task_status.rb'

  # Add more helper methods to be used by all tests here...
  def login_as(user)
    post login_submit_path, params: { email: user.email, password: user.password, role: user.class.name }
    assert_redirected_to projects_path
  end

end
