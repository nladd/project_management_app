require "test_helper"

class TaskTest < ActiveSupport::TestCase

  setup do
    @task = tasks(:one)
    project = projects(:one)
    @project_manager = project_managers(:one)
    @employee = employees(:one)

    @task.update(task_status: TaskStatus.not_started,
                 project_manager: @project_manager,
                 employee: @employee,
                 project: project)
  end

  test "updating due_date creates a scheduled job" do
    MarkLateTaskJob.jobs.clear
    assert_equal(MarkLateTaskJob.jobs.size, 0)
    @task.update(due_date: Date.today + 5.days)
    assert_equal(MarkLateTaskJob.jobs.size, 1)
    assert_empty(@task.errors)
  end

  test "#restricted_update prevents project managers from changing status to working" do
    assert_equal(@task.task_status_id, TaskStatus.not_started.id)

    @task.restricted_update({task_status: TaskStatus.working}, @project_manager)
    assert_equal(@task.reload.task_status_id, TaskStatus.not_started.id)
    assert_not_empty(@task.errors[:task_status_id])
  end

  test "#restricted_update prevents project managers from changing status to need_review" do
    assert_equal(@task.task_status_id, TaskStatus.not_started.id)

    @task.restricted_update({task_status: TaskStatus.needs_review}, @project_manager)
    assert_equal(@task.reload.task_status_id, TaskStatus.not_started.id)
    assert_not_empty(@task.errors[:task_status_id])
  end

  test "only the assigned employee can update the task's status to working" do
    not_assigned_employee = employees(:two)
    assert_equal(@task.task_status_id, TaskStatus.not_started.id)

    @task.restricted_update({task_status: TaskStatus.working}, not_assigned_employee)
    assert_equal(@task.reload.task_status_id, TaskStatus.not_started.id)
    assert_not_empty(@task.errors[:task_status_id])

    @task.restricted_update({task_status: TaskStatus.working}, @employee)
    assert_equal(@task.reload.task_status_id, TaskStatus.working.id)
  end

  test "only the assigned employee can update the task's status to needs review" do
    not_assigned_employee = employees(:two)
    assert_equal(@task.task_status_id, TaskStatus.not_started.id)

    @task.restricted_update({task_status: TaskStatus.needs_review}, not_assigned_employee)
    assert_equal(@task.reload.task_status_id, TaskStatus.not_started.id)
    assert_not_empty(@task.errors[:task_status_id])

    @task.restricted_update({task_status: TaskStatus.needs_review}, @employee)
    assert_equal(@task.reload.task_status_id, TaskStatus.needs_review.id)
  end

end
