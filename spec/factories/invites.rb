FactoryBot.define do
  factory :invite, class: ::Permits::Invite do
    association :invited_by, factory: :user
    association :invitee, factory: :user

    email { Faker::Internet.email }
    slug { Faker::Internet.slug }
    started_at { Time.current }
  end

  trait :group_invitation do
    after(:create) do |invite|
      group = create(:group)
      create(:permission, :edit, owner: invite, resource: group)
    end
  end
end
