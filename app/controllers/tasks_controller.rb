class TasksController < ApplicationController
    
    before_action :require_user_logged_in
    before_action :correct_user, only: [:destroy]

    
    def index
       @tasks = Task.all#.page(params[:page]).per(3)
        
    if logged_in?
      @task = current_user.tasks.build  # form_with 用
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
    end
        
    end
    
    def show
        @task = Task.find(params[:id])
    end
    
    def new
       @task = Task.new
    end
    
    def create 
=begin    
        @task = Task.new(task_params)
        
        if @task.save
            flash[:success] = "タスクが正常に投稿されました"
            redirect_to @task  
            
        else 
            flash.now[:danger] = "タスクが投稿されませんでした"
            render :new
        end
=end
        
         @task = current_user.tasks.build(task_params)
        if @task.save
          flash[:success] = 'メッセージを投稿しました。'
          redirect_to root_url and return
        else
          @tasks = current_user.tasks.order(id: :desc).page(params[:page])
          flash.now[:danger] = 'メッセージの投稿に失敗しました。'
          render 'tasks/index'
        end    
    end
    
    def edit
        @task = Task.find(params[:id])
    end
    
    def update
         @task = Task.find(params[:id])

        if @task.update(task_params)
          flash[:success] = 'タスク は正常に更新されました'
          redirect_to @task
        else
          flash.now[:danger] = 'タスクは更新されませんでした'
          render :edit
        end
    end
    
    def destroy
=begin
        @task = Task.find(params[:id])
        @task.destroy
        
        flash[:success] = 'タスク は正常に削除されました'
        redirect_to tasks_url
=end       
         @task.destroy
        flash[:success] = 'メッセージを削除しました。'
        redirect_back(fallback_location: root_path)
    end
    
      private

  # Strong Parameter
 
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end 
end
