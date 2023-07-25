class ApplicationController < ActionController::Base

    skip_before_action :verify_authenticity_token, if: Proc.new { request.format.json? }
    before_action :authenticate_user


    private

    def load_user
        return nil if login_key.nil?
        @current_user = user_role.constantize.find_by(login_key: login_key)
    end

    def authenticate_user
        if load_user
            session[:login_key] == @current_user.login_key unless request.format.json?
        else
            respond_to do |format|
                format.html { redirect_to root_path, flash: {error: 'Must be logged in'} }
                format.json { render json: {message: "Must be logged in"}, status: :forbidden}
            end
        end
    end

    def project_manager_only
        unless user_role == ProjectManager.name
            redirect_back_or_to :projects_path, flash: {error: "Permission denied"}
        end
    end

    def user_role
        login_key.split('::')[0]
    end

    def login_key
        return @login_key if @login_key.present?
        @login_key ||= if request.format.json?
                            authenticate_or_request_with_http_token do |token, _options|
                                token
                            end
                        else
                            session[:login_key]
                        end
    end

end
