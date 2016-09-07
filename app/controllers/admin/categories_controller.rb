class Admin::CategoriesController < AdminController
  def index
    @categories = Category.all
    set_page_title_and_description("分类管理", nil)
  end

  def new
    @category = Category.new
    set_page_title_and_description("新建分类", nil)
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def show
    @category = Category.find(params[:id])
    set_page_title_and_description("分类-#{@category.chs_name}", nil)
  end

  def edit
    @category = Category.find(params[:id])
    set_page_title_and_description("编辑分类-#{@category.chs_name}", nil)
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      flash[:notice] = "分类更新成功"
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      flash[:notice] = "分类删除成功"
      redirect_to admin_categories_path
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :chs_name)
  end
end
