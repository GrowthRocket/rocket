module ProjectsHelper
  def render_project_description(project)
     simple_format(project.description)
  end
end
