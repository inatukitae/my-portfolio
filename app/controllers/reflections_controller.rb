class ReflectionsController < ApplicationController
  # index では set_post を実行しないように except で除外する
  before_action :set_post, except: [:index, :toggle_hidden]
  before_action :set_reflection, only: [:edit, :update]
  def index
    if params[:show_hidden] == 'true'
      # すべて（非表示にしたものも含む）取得
      @reflections = Reflection.joins(:post).where(posts: { user_id: current_user.id })
      @showing_hidden = true
    else
      # デフォルトは未完了（非表示になっていないもの）だけ取得
      @reflections = Reflection.joins(:post).where(posts: { user_id: current_user.id }, hidden: false)
      @showing_hidden = false
    end
  end

  def new
    if @post.reflection.present?
      redirect_to edit_post_reflection_path(@post), notice: 'すでに深掘りが登録されています。編集してください。'
    else
      @reflection = @post.build_reflection
    end
  end

  def create
    @reflection = @post.build_reflection(reflection_params)
    if @reflection.save
      redirect_to post_path(@post), notice: '深掘りを登録しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @reflection.update(reflection_params)
      redirect_to post_path(@post), notice: '深掘りを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def toggle_hidden
    @reflection = Reflection.joins(:post).where(posts: { user_id: current_user.id }).find(params[:id])
    @reflection.update(hidden: !@reflection.hidden)
    redirect_to reflections_path(show_hidden: params[:show_hidden]), notice: 'ステータスを更新しました。'
  end

  private

  def set_post
    @post = current_user.posts.find(params[:post_id])
  end

  def set_reflection
    @reflection = @post.reflection
  end

  def reflection_params
    params.require(:reflection).permit(:solution, :prevention, :hidden)
  end
end