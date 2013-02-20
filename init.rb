require 'redmine_custom_overview'

Redmine::Plugin.register :redmine_custom_overview do
  name 'Redmine Custom Overview'
  author      '//Twinslash'
  description "Plugin change project's overview"
  version     '0.0.1'
  url         'https://github.com/twinslash/redmine_custom_overview'
  author_url  'http://twinslash.com'

  project_module :overview do
    permission :wiki, { :wiki => nil }
    permission :wall, { :wall => nil }
    permission :activity, { :activity => nil }
    permission :roadmap, { :roadmap => nil }
    permission :members, { :members => nil }
    permission :latest_news, { :latest_news => nil }
  end
end
