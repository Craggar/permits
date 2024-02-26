module Permits
  describe Invite, type: :model do
    describe "validations" do
      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:aasm_state) }
      it { should validate_presence_of(:slug) }
    end

    describe "associations" do
      it { should belong_to(:invited_by) }
      it { should belong_to(:invitee).optional }
    end

    describe "attributes" do
      it "has a valid factory" do
        expect(build(:invite)).to be_valid
      end
    end

    describe "state machine" do
      let(:group) { create(:group) }
      let!(:invite) { create(:invite) }
      let!(:invite_permission) { create(:permission, resource: group, permits: :edit, owner: invite) }

      it "starts in the pending state" do
        expect(invite).to be_pending
      end

      context "when the invite is accepted" do
        it "copies the permission to the invitee" do
          invite.accept!
          invitee_permission = invite.invitee.permissions.first

          expect(invite).to be_accepted
          expect(::Permits::Policy::Base.authorized?(invite.invitee, group, :edit)).to eq(true)
          expect(invitee_permission.started_at).to be_within(1.second).of(Time.current)
          expect(invitee_permission.ended_at).to be_nil
          expect(invitee_permission.permits).to eq("edit")
          expect(invitee_permission.resource).to eq(group)

          expect(invite.reload.permissions).to be_empty
          expect(::Permits::Policy::Base.authorized?(invite, group, :edit)).to eq(false)
        end
      end

      context "when the invite is declined" do
        it "does not create permissions for the invitee" do
          invite.decline!
          invite_permission = invite.permissions.first

          expect(invite).to be_declined
          expect(invite_permission.ended_at).to be_within(1.second).of(Time.current)
          expect(::Permits::Policy::Base.authorized?(invite, group, :edit)).to eq(false)
          expect(invite.invitee.permissions).to be_empty
        end
      end
    end
  end
end
