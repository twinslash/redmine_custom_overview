module CustomOverview
  module ProjectsControllerPatch

    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        # TODO maybe skip some filters to make loading faster

        # helper :versions

        def show
          [:wiki, :wall, :roadmap, :members, :latest_news, :spent_time].each do |permission|
            send("load_#{permission}") if User.current.allowed_to?(:"custom_overview_#{permission}", @project)
          end
        end

      end
    end

    module InstanceMethods

      private

      def load_wiki
      end

      def load_wall
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
