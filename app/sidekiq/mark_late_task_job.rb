class MarkLateTaskJob
  include Sidekiq::Job

  def perform(task_id, klass)
    if task = klass.constantize.find(task_id)
        task.update(task_status_id: TaskStatus.late.id)
    end
  end
end
