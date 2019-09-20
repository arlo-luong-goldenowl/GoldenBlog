class Admin::CategoriesController < Admin::BaseAdminController
  before_action :prepare_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.order(created_at: :desc).paginate(page: params[:page], per_page: 8)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Category was successfully created"
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update_attributes(category_params)
      flash[:success] = "Category was successfully updated"
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    if @category.posts.count > 0
      flash[:danger] = 'You can only delete when no more posts belong to this category'
      return redirect_to admin_categories_path
    end

    if @category.destroy
      flash[:success] = 'Category was successfully deleted.'
      redirect_to admin_categories_path
    else
      flash[:danger] = 'Something went wrong'
      redirect_to admin_categories_path
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def prepare_category
    @category = Category.find(params[:id])
  end
end
