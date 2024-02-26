module Policy
  class SuperUserOnlyPolicy < ::Permits::Policy::Base
    def super_user?
      has_action_permissions?(:super_user)
    end

    def read?
      has_action_permissions?(:super_user)
    end

    def edit?
      has_action_permissions?(:super_user)
    end

    def create?
      has_action_permissions?(:super_user)
    end

    def destroy?
      has_action_permissions?(:super_user)
    end

    def invite?
      has_action_permissions?(:super_user)
    end
  end
end
