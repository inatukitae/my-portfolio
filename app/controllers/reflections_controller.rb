class ReflectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [ :new, :create, :edit, :update ]
  before_action :set_reflection, only: [ :edit, :update, :toggle_hidden ]

  def index
    base_scope = policy_scope(Reflection)
    if params[:show_hidden] == "true"
      @reflections = base_scope.all
      @showing_hidden = true
    else
      @reflections = base_scope.where(hidden: false)
      @showing_hidden = false
    end
  end

  def new
    @reflection = @post.build_reflection
    authorize @reflection
  end

  def create
    @reflection = @post.build_reflection(reflection_params)
    authorize @reflection
    if @reflection.save
      redirect_to post_path(@post), notice: "深掘りを登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @reflection
  end

  def update
    authorize @reflection
    if @reflection.update(reflection_params)
      redirect_to post_path(@post), notice: "深掘りを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def toggle_hidden
    @reflection = Reflection.find(params[:id])
    authorize @reflection, :toggle_hidden?
    @reflection.update_columns(hidden: !@reflection.hidden)
    redirect_to reflections_path, notice: "ステータスを更新しました。"
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_reflection
    if params[:id].present?
      @reflection = Reflection.find(params[:id])
    elsif @post.present?
      @reflection = @post.reflection
    end
  end

  def reflection_params
    params.require(:reflection).permit(:solution, :prevention, :hidden)
  end
end
