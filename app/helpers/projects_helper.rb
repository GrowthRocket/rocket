module ProjectsHelper
  def render_project_description(project)
    sanitize(project.description)
  end

  def render_project_name(project)
    link_to(project.name, project_path(project))
  end

  def render_project_image(project, _size = :thumb)
    image_tag(project.image.small, width: 120, height: 75)
  end

  def render_project_funding_progress(project)
    number_with_precision(project.fund_progress.to_f / project.fund_goal * 100, precision: 2) + " %"
  end

  def render_highlight_content(project, query_string)
    excerpt_cont = excerpt(project.name, query_string, radius: 500)
    highlight(excerpt_cont, query_string)
  end

  def render_search_empty_result
    content_tag :div, class: "text-center" do
      content_tag :span, "暂时还没有包含这个关键词的项目哦，请换一个关键词再试一下。"
    end
  end

  def render_progress_show(percent)
    percent = percent.to_s + "%"
    content_tag :div, class: "progress sh-progress-whole" do
      content_tag :div, class: %w(progress-bar sh-progress-content), role: "progressbar", 'aria-valuenow': percent, 'aria-valuemin': "0", 'aria-valuemax': "100", 'style': "width: "+ percent + ";min-width:2em;"  do
      end
    end
  end




end
