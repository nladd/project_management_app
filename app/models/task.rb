require 'sidekiq/api'

class Task < ApplicationRecord

    belongs_to :employee
    belongs_to :project_manager
    belongs_to :task_status
    belongs_to :project

    has_many :sub_tasks, dependent: :destroy

    validates_presence_of :project_id

    after_save :schedule_mark_late_task_job, if: :saved_change_to_due_date?



    def restricted_update(attrs, user)
        # the task_status_id can be updated by passing a integer to the task_status_id attr or a TaskStatus object
        # to the task_status attribute. In the case of the former, convert to a TaskStatus object to determine if 
        # the status is valid and to allow for conditional checks if the update is permitted
        if attrs[:task_status_id].present?
            if task_status = TaskStatus.find_by(id: attrs[:task_status_id])
                attrs[:task_status] = task_status
            else
                errors.add(:task_status_id, "Invalid task_status_id")
                return false
            end
        end

        #Only the assigned project manager can switch Task to working, and needs review statuses
        if attrs[:task_status] == TaskStatus.done && 
            (user.class != ProjectManager || user.id != project_manager_id)
            errors.add(:task_status_id, "Only the assigned project manager can change the status to done")
            false
        #Only the assigned Employee can switch Task to working, and needs review statuses
        elsif [TaskStatus.working, TaskStatus.needs_review].include?(attrs[:task_status]) &&
            (user.class != Employee || user.id != employee_id)
            errors.add(:task_status_id, "Only the assigned employee can change the status to #{attrs[:task_status].name}")
            false
        else
            update(attrs)
        end
    end

    private

    def schedule_mark_late_task_job
        # Sidekiq's API does not have a testing mode, therefore Sidekiq::ScheduledSet.new will always hit Redis.
        # it's out of scope for this assignment to setup a testing env for the Sidekiq API
        unless Rails.env.test?
            # first delete the old job so we don't have more than one job scheduled to mark the task as late
            ss = Sidekiq::ScheduledSet.new
            job = ss.find_job(mark_late_task_jid)
            job.delete if job.present?
        end

        jid = MarkLateTaskJob.perform_at(Time.parse(due_date.to_s) + 1.day, Task.name)
        update(mark_late_task_jid: jid)
    end
end
