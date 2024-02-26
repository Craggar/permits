require "active_support/concern"

module Permits
  module HasPermissions
    extend ActiveSupport::Concern

    included do
      has_many :permissions, -> { active }, as: :owner, class_name: "::Permits::Permission", dependent: :destroy
    end
  end
end
