class ProjectManager < ApplicationRecord
    include UserAuthentication

    has_many :employees
    has_many :projects
    has_many :tasks

    validates :email, uniqueness: true, presence: true
    validates :password, presence: true, length: 6..20
end
