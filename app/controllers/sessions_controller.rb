class SessionsController < ApplicationController

    skip_before_action :authenticate_user, except: [:destroy]

    def index
    end

    def show
    end

    def employee_login
    end

    def project_manager_login
    end

    def create
        email = params[:email]
        begin
            role = params[:role].constantize
        rescue NameError
            # invalid role parameter was passed
            user = nil
        else
            user = role.find_by(email: email)
        end

        if user.present? && user.authenticate_with_password!(params[:password])
            session[:login_key] = user.login_key
            respond_to do |format|
                format.html { redirect_to projects_path }
                format.json { render json: {login_key: user.login_key} }
            end
        else
            respond_to do |format|
                format.html { redirect_back_or_to root_path, flash: {error: 'Invalid login credentials'} }
                format.json { render json: { error: 'Invalid login credentials' }, status: 403 }
            end
        end
    end

    def destroy
        @current_user.update(login_key: nil) if @current_user
        respond_to do |format|
            format.html { redirect_to root_path }
            format.json { render json: {message: "Logout successful"}}
        end
    end
end
