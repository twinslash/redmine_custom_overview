module CustomOverview
  module ProjectsControllerPatch

    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        helper :versions

        alias_method_chain :show, :custom_overview

      end
    end

    module InstanceMethods

      def show_with_custom_overview
        if @project.enabled_module_names.include?('custom_overview')
          [:wiki, :roadmap, :members, :latest_news, :spent_time].each do |permission|
            send("load_#{permission}") if User.current.allowed_to?(:"custom_overview_#{permission}", @project)
          end
          render 'custom_overview'
        else
          show_without_custom_overview
        end
      end

      private

      def load_wiki
        @wiki = @project.wiki
        @page = @wiki.find_page('Overview') || @wiki.find_page('overview')
        @content = @page.try(:content)
      end

      def load_roadmap
        @versions = @project.shared_versions.open.visible.all(:conditions => 'effective_date IS NOT NULL')
      end

      def load_members
        @users_by_role = @project.users_by_role
      end

      def load_latest_news
        @news = @project.news.find(:all, :limit => 5, :include => [ :author, :project ], :order => "#{News.table_name}.created_on DESC")
      end

      def load_spent_time
        # calculate total_hours
        if User.current.allowed_to?(:view_time_entries, @project)
          cond = @project.project_condition(Setting.display_subprojects_issues?)
          @total_hours = TimeEntry.visible.sum(:hours, :include => :project, :conditions => cond).to_f
        end
      end

    end

  end
end
