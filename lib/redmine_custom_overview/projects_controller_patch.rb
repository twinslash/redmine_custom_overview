module CustomOverview
  module ProjectsControllerPatch

    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        # TODO maybe skip some filters to make loading faster

        def show
          [:wiki, :wall, :activity, :roadmap, :members, :latest_news, :spent_time].each do |permission|
            send("load_#{permission}") if User.current.allowed_to?(:"custom_overview_#{permission}", @project)
          end
        end

      end
    end

    module InstanceMethods

      private

      def load_wiki
        @wiki = 'load_wiki'
      end

      def load_wall
        @wall = 'load_wall'
      end

      def load_activity
        @activity = 'load_activity'
      end

      def load_roadmap
        @roadmap = 'load_roadmap'
      end

      def load_members
        @members = 'load_members'
      end

      def load_latest_news
        @latest_news = 'load_latest_news'
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
