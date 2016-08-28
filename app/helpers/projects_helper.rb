module ProjectsHelper
  def render_project_description(project)
    simple_format(project.description)
  end

  def render_project_image(project, _size = :thumb)
    image_tag(project.image.thumb, width: 123, height: 90)
  end

  def render_project_funding_progress(project)
    number_with_precision(project.fund_progress.to_f / project.fund_goal * 100, precision: 2) + " %"
  end

  def render_highlight_content(project,query_string)
    excerpt_cont = excerpt(project.name, query_string, radius: 500)
    highlight(excerpt_cont, query_string)
  end

  def render_search_empty_result
    content_tag :div, class: "text-center" do
      content_tag :span, "暂时还没有以这个名称命名的项目哦，请换一个项目名字再试一下"
    end
  end


end
