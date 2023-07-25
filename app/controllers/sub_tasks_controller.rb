class SubTasksController < ApplicationController

  # only project managers can create and destroy tasks
  before_action :project_manager_only, only: %i[new create destroy]
  before_action :set_sub_task, only: %i[ show edit update destroy ]

  # GET /sub_tasks or /sub_tasks.json
  def index
    @sub_tasks = if params[:user_id].present?
                    @current_user.sub_tasks
                  elsif params[:task_id].present?
                    @task = Task.find(params[:task_id])
                    @task.sub_tasks
                  else
                    @tasks = SubTask.all
                  end
  end

  # GET /sub_tasks/1 or /sub_tasks/1.json
  def show
  end

  # GET /sub_tasks/new
  def new
    @sub_task = SubTask.new
  end

  # GET /sub_tasks/1/edit
  def edit
  end

  # POST /sub_tasks or /sub_tasks.json
  def create
    @sub_task = SubTask.new(sub_task_params)

    respond_to do |format|
      if @sub_task.save
        format.html { redirect_to sub_task_url(@sub_task), notice: "Sub task was successfully created." }
        format.json { render :show, status: :created, location: @sub_task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sub_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sub_tasks/1 or /sub_tasks/1.json
  def update
    respond_to do |format|
      if @sub_task.restricted_update(sub_task_params, @current_user)
        format.html { redirect_to sub_task_url(@sub_task), notice: "Sub task was successfully updated." }
        format.json { render :show, status: :ok, location: @sub_task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sub_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_tasks/1 or /sub_tasks/1.json
  def destroy
    @sub_task.destroy

    respond_to do |format|
      format.html { redirect_to sub_tasks_url, notice: "Sub task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_task
      @sub_task = SubTask.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sub_task_params
      params.require(:sub_task).permit(:title, :work_focus, :description, :due_date, :task_status_id, :task_id, :employee_id)
    end
end
