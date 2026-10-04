class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: %i[edit update destroy]

  def index
    @status = params[:status].presence_in(%w[all pending completed]) || "all"
    @todos = current_user.todos

    case @status
    when "pending"
      @todos = current_user.todos.where(completed: false).or(current_user.todos.where(completed: nil))
    when "completed"
      @todos = current_user.todos.where(completed: true)
    end

    @todos = @todos.order(created_at: :desc)
  end

  def new
    @todo = current_user.todos.build
  end

  def create
    @todo = current_user.todos.build(todo_params)

    if @todo.save
      redirect_to todos_path, notice: "Todo created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @todo.update(todo_params)
      redirect_to todos_path, notice: "Todo updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @todo.destroy
    redirect_to todos_path, notice: "Todo deleted successfully."
  end

  private

  def set_todo
    @todo = current_user.todos.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :completed)
  end
end
