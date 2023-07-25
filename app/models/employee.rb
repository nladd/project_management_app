class Employee < ApplicationRecord
    include UserAuthentication

    belongs_to :project_manager
    has_many :tasks
    has_many :sub_tasks

    validates :email, uniqueness: true, presence: true
    validates :password, presence: true, length: 6..20
    
end
