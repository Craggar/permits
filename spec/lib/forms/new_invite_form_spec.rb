module Permits
  module Forms
    describe NewInviteForm, type: :model do
      describe "validations" do
        it { should validate_presence_of(:invited_by) }
        it { should validate_presence_of(:email) }
      end

      let(:invited_by) { create(:user) }
      let(:email) { Faker::Internet.email }
      let(:permission_attributes) { nil }
      let!(:form) { described_class.new(invited_by: invited_by, email: email, permission_attributes: permission_attributes) }

      describe "save" do
        context "without permissions" do
          it "creates an invite" do
            expect { form.save }.to change { Invite.count }.by(1)
            expect(Invite.last.invited_by).to eq(invited_by)
            expect(Invite.last.email).to eq(email)
            expect(Invite.last.invitee).to be_nil
            expect(Invite.last.started_at).to be_within(1.second).of(Time.current)
          end

          it "does not assign any permissions to the form" do
            expect { form.save }.to_not change { ::Permits::Permission.count }
            expect(form.invite.reload.permissions).to be_empty
          end
        end

        context "with attached permissions" do
          let(:group_one) { create(:group) }
          let(:group_two) { create(:group) }

          let(:permission_attributes) do
            {
              group_one => ["read", "edit"],
              group_two => ["super_user", "destroy"]
            }
          end

          context "invited_by has invite permissions for all resources" do
            let!(:group_one_invite_permissions) { create(:permission, permits: :invite, resource: group_one, owner: invited_by) }
            let!(:group_two_invite_permissions) { create(:permission, permits: :invite, resource: group_two, owner: invited_by) }

            it "creates permissions for the invite", aggregate_failures: true do
              expect { form.save }.to change { ::Permits::Permission.count }.by(4)
              invite = ::Permits::Invite.last
              expect(invite.permissions.count).to eq(4)
              expect(::Permits::Policy::Base.authorized?(invite, group_one, :super_user)).to eq(false)
              expect(::Permits::Policy::Base.authorized?(invite, group_one, :read)).to eq(true)
              expect(::Permits::Policy::Base.authorized?(invite, group_one, :edit)).to eq(true)
              expect(::Permits::Policy::Base.authorized?(invite, group_one, :create)).to eq(false)
              expect(::Permits::Policy::Base.authorized?(invite, group_one, :destroy)).to eq(false)

              expect(::Permits::Policy::Base.authorized?(invite, group_two, :super_user)).to eq(true)
              expect(::Permits::Policy::Base.authorized?(invite, group_two, :read)).to eq(false)
              expect(::Permits::Policy::Base.authorized?(invite, group_two, :edit)).to eq(false)
              expect(::Permits::Policy::Base.authorized?(invite, group_two, :create)).to eq(false)
              expect(::Permits::Policy::Base.authorized?(invite, group_two, :destroy)).to eq(true)
            end
          end

          context "a resource has a custom policy for permission checks" do
            let!(:group_one_invite_permissions) { create(:permission, permits: :invite, resource: group_one, owner: invited_by) }
            let!(:group_two_invite_permissions) { create(:permission, permits: :invite, resource: group_two, owner: invited_by) }

            before do
              allow(group_one).to receive(:policy_class).and_return(
                ::Policy::SuperUserOnlyPolicy
              )
            end

            it "checks permissions against the custom policy" do
              expect(::Policy::SuperUserOnlyPolicy).to receive(:authorized?).with(invited_by, group_one, :invite).exactly(1).times.and_call_original
              expect(::Permits::Policy::Base).to receive(:authorized?).with(invited_by, group_two, :invite).exactly(1).times.and_call_original

              form.save
            end
          end

          context "invited_by has invite permissions for some resources" do
            let!(:group_one_invite_permissions) { create(:permission, permits: :invite, resource: group_one, owner: invited_by) }

            it "creates permissions for the invite where it can", aggregate_failures: true do
              expect { form.save }.to change { ::Permits::Permission.count }.by(2)
              invite = ::Permits::Invite.last
              expect(invite.permissions.count).to eq(2)
              expect(::Permits::Policy::Base.authorized?(invite, group_one, :super_user)).to eq(false)
              expect(::Permits::Policy::Base.authorized?(invite, group_one, :read)).to eq(true)
              expect(::Permits::Policy::Base.authorized?(invite, group_one, :edit)).to eq(true)
              expect(::Permits::Policy::Base.authorized?(invite, group_one, :create)).to eq(false)
              expect(::Permits::Policy::Base.authorized?(invite, group_one, :destroy)).to eq(false)

              expect(::Permits::Policy::Base.authorized?(invite, group_two, :super_user)).to eq(false)
              expect(::Permits::Policy::Base.authorized?(invite, group_two, :read)).to eq(false)
              expect(::Permits::Policy::Base.authorized?(invite, group_two, :edit)).to eq(false)
              expect(::Permits::Policy::Base.authorized?(invite, group_two, :create)).to eq(false)
              expect(::Permits::Policy::Base.authorized?(invite, group_two, :destroy)).to eq(false)
            end
          end

          context "invited_by has no invite permissions" do
            it "does not create any permissions for the invite" do
              expect { form.save }.to_not change { ::Permits::Permission.count }
              expect(form.invite.reload.permissions).to be_empty
            end
          end
        end
      end
    end
  end
end
