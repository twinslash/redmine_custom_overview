require 'redmine_custom_overview/projects_controller_patch'

Rails.configuration.to_prepare do
  ProjectsController.send(:include, CustomOverview::ProjectsControllerPatch)
end
