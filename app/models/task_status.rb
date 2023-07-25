class TaskStatus < ApplicationRecord

    has_many :tasks
    has_many :sub_tasks

    validates_uniqueness_of :name

    TaskStatus.all.each do |task_status|
        class_eval %{
            def self.#{task_status.name.downcase.parameterize.underscore}
                find_by(name: '#{task_status.name}')
            end
        }
    end
end
