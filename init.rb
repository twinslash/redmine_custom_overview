require 'redmine_custom_overview'

Redmine::Plugin.register :redmine_custom_overview do
  name 'Redmine Custom Overview'
  author      '//Twinslash'
  description "Plugin change project's overview"
  version     '0.0.1'
  url         'https://github.com/twinslash/redmine_custom_overview'
  author_url  'http://twinslash.com'

  project_module :custom_overview do
    permission :custom_overview_wiki, { :custom_overview_wiki => nil }
    permission :custom_overview_roadmap, { :custom_overview_roadmap => nil }
    permission :custom_overview_members, { :custom_overview_members => nil }
    permission :custom_overview_latest_news, { :custom_overview_latest_news => nil }
    permission :custom_overview_spent_time, { :custom_overview_spent_time => nil }
  end
end
