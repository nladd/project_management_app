require "test_helper"

class SubTaskTest < ActiveSupport::TestCase

  setup do
    @sub_task = sub_tasks(:one)
    project = projects(:one)
    task = tasks(:one)
    @employee = employees(:one)

    @sub_task.update(task_status: TaskStatus.not_started,
                 employee: @employee,
                 task: task)
  end

  test "updating due_date creates a scheduled job" do
    MarkLateTaskJob.jobs.clear
    assert_equal(MarkLateTaskJob.jobs.size, 0)
    @sub_task.update(due_date: Date.today + 5.days)
    assert_equal(MarkLateTaskJob.jobs.size, 1)
    assert_empty(@sub_task.errors)
  end

  test "#restricted_update prevents project managers from changing status to working" do
    assert_equal(@sub_task.task_status_id, TaskStatus.not_started.id)

    @sub_task.restricted_update({task_status: TaskStatus.working}, @project_manager)
    assert_equal(@sub_task.reload.task_status_id, TaskStatus.not_started.id)
    assert_not_empty(@sub_task.errors[:task_status_id])
  end

  test "#restricted_update prevents project managers from changing status to need_review" do
    assert_equal(@sub_task.task_status_id, TaskStatus.not_started.id)

    @sub_task.restricted_update({task_status: TaskStatus.needs_review}, @project_manager)
    assert_equal(@sub_task.reload.task_status_id, TaskStatus.not_started.id)
    assert_not_empty(@sub_task.errors[:task_status_id])
  end

  test "only the assigned employee can update the sub task's status to working" do
    not_assigned_employee = employees(:two)
    assert_equal(@sub_task.task_status_id, TaskStatus.not_started.id)

    @sub_task.restricted_update({task_status: TaskStatus.working}, not_assigned_employee)
    assert_equal(@sub_task.reload.task_status_id, TaskStatus.not_started.id)
    assert_not_empty(@sub_task.errors[:task_status_id])

    @sub_task.restricted_update({task_status: TaskStatus.working}, @employee)
    assert_equal(@sub_task.reload.task_status_id, TaskStatus.working.id)
  end

  test "only the assigned employee can update the sub task's status to needs review" do
    not_assigned_employee = employees(:two)
    assert_equal(@sub_task.task_status_id, TaskStatus.not_started.id)

    @sub_task.restricted_update({task_status: TaskStatus.needs_review}, not_assigned_employee)
    assert_equal(@sub_task.reload.task_status_id, TaskStatus.not_started.id)
    assert_not_empty(@sub_task.errors[:task_status_id])

    @sub_task.restricted_update({task_status: TaskStatus.needs_review}, @employee)
    assert_equal(@sub_task.reload.task_status_id, TaskStatus.needs_review.id)
  end
end
