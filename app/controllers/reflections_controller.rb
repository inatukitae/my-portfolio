class ReflectionsController < ApplicationController
  before_action :authenticate_user!
  # index では set_post を実行しないように except で除外する
  before_action :set_post, except: [ :index, :toggle_hidden ]
  before_action :set_reflection, only: [ :edit, :update ]

  def index
    if params[:show_hidden] == "true"
      @reflections = Reflection.joins(:post).where(posts: { user_id: current_user.id })
      @showing_hidden = true
    else
      @reflections = Reflection.joins(:post).where(posts: { user_id: current_user.id }, hidden: false)
      @showing_hidden = false
    end
  end

  def new
    @reflection = @post.build_reflection
    authorize @reflection # 必要に応じて作成の認可
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
    authorize @reflection # 編集の認可
  end

  def update
    authorize @reflection # 更新の認可
    if @reflection.update(reflection_params)
      redirect_to post_path(@post), notice: "深掘りを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def toggle_hidden
    @reflection = Reflection.find(params[:id])
    authorize @reflection # 非公開切り替えの認可（ReflectionPolicy#toggle_hidden? が呼ばれます）
    @reflection.update(hidden: !@reflection.hidden)
    redirect_to reflections_path(show_hidden: params[:show_hidden]), notice: "ステータスを更新しました。"
  end

  private

  def set_post
    @post = current_user.posts.find(params[:post_id])
  end

  def set_reflection
    @reflection = @post.reflection
    # 存在しない場合のハンドリングやセキュリティ強化のため、必要に応じてここで所有者チェックや404処理を入れることもできます
  end

  def reflection_params
    params.require(:reflection).permit(:solution, :prevention, :hidden)
  end
end
