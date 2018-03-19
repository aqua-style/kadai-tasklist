class TasksController < ApplicationController

  before_action :require_user_logged_in, only: [:show, :edit, :new] #ログインしてなければログイン画面に飛ばすだけ
  before_action :correct_user, only: [:destroy, :show, :edit] #ユーザーとタスクが紐付いてるかのチェック　他人のを直URLでいじれないようにする

  def index
    @tasks = Task.all.page(params[:page])
  end

  def show
      @task = Task.find(params[:id])
  end


  def new
      @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    puts '◆出力テスト'
    puts @task

    if @task.save
      flash[:success] = 'タスクが正常に登録されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクの登録ができませんでした'
      render :new
    end
  end


  def edit
    @task = Task.find(params[:id])
  end


  def update
    @task = Task.find(params[:id])
    puts '◆出力テストupdate @task'
    puts @task
    
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクは更新されませんでした'
      render :edit
    end
  end


  def destroy
    #correct_user作成により削除 @task = Task.find(params[:id])
    @task.destroy

    flash[:success] = 'タスクは正常に削除されました'
    redirect_to user_url #もともとはtasks_url、 USER詳細画面へ遷移させたいので
  end

  
  private

  # Strong Parameter
  def task_params
    params.require(:task).permit(:content,:status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    puts '◆出力テスト correct_user' 
    puts params[:id]
    unless @task
      redirect_to root_url
    end
  end
end