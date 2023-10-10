FactoryBot.define do
  factory :permission, class: Permits::Permission do
    association :owner, factory: :user
    association :resource, factory: :group

    permits { :read }

    trait :super_user do
      permits { :super_user }
    end

    trait :read do
      permits { :read }
    end

    trait :edit do
      permits { :edit }
    end

    trait :create do
      permits { :create }
    end

    trait :destroy do
      permits { :destroy }
    end
  end
end
