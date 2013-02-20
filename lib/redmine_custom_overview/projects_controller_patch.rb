module CustomOverview
  module ProjectsControllerPatch

    def self.included(base)
      base.class_eval do

        def show

        end

      end
    end

  end
end
