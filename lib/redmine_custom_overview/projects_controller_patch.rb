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
      end

      def load_wall
      end

      def load_activity

        @days = Setting.activity_days_default.to_i

        @date_to ||= Date.today + 1
        @date_from = @date_to - @days
        @with_subprojects = Setting.display_subprojects_issues?
        @author = nil

        @activity = Redmine::Activity::Fetcher.new(User.current, :project => @project,
                                                                 :with_subprojects => @with_subprojects,
                                                                 :author => @author)
        @activity.scope_select {|t| !params["show_#{t}"].nil?}
        @activity.scope = :default if @activity.scope.empty?

        events = @activity.events(@date_from, @date_to)

        if events.empty? || stale?(:etag => [@activity.scope, @date_to, @date_from, @with_subprojects, @author, events.first, events.size, User.current, current_language])
          @events_by_day = events.group_by {|event| User.current.time_to_date(event.event_datetime)}
        end

      end

      def load_roadmap
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
