module Permits
  module Forms
    describe InviteForm, type: :model do
      describe "validations" do
        it { should validate_presence_of(:invite_id) }
        it { should validate_presence_of(:invited) }
        it { should validate_presence_of(:token) }
      end

      let(:invited_user) { create(:user) }
      let(:token) { SecureRandom.hex(3).upcase }
      let(:valid_invite) { create(:invite, email: invited_user.email, slug: token) }

      describe "accept" do
        context "valid invite" do
          it "accepts the invite" do
            form = described_class.new(invite_id: valid_invite.id, invited: invited_user, token: token)
            expect(form.accept).to eq(true)
            expect(valid_invite.reload).to be_accepted
          end
        end

        context "emails do not match" do
          it "does not accept the invite" do
            other_user = create(:user)
            form = described_class.new(invite_id: valid_invite.id, invited: other_user, token: token)
            expect(form.accept).to eq(false)
            expect(valid_invite.reload).to be_pending
          end
        end

        context "tokens do not match" do
          it "does not accept the invite" do
            form = described_class.new(invite_id: valid_invite.id, invited: invited_user, token: "invalid")
            expect(form.accept).to eq(false)
            expect(valid_invite.reload).to be_pending
          end
        end
      end

      describe "decline" do
        context "valid invite" do
          it "declines the invite" do
            form = described_class.new(invite_id: valid_invite.id, invited: invited_user, token: token)
            expect(form.decline).to eq(true)
            expect(valid_invite.reload).to be_declined
          end
        end

        context "emails do not match" do
          it "does not decline the invite" do
            other_user = create(:user)
            form = described_class.new(invite_id: valid_invite.id, invited: other_user, token: token)
            expect(form.decline).to eq(false)
            expect(valid_invite.reload).to be_pending
          end
        end

        context "tokens do not match" do
          it "does not decline the invite" do
            form = described_class.new(invite_id: valid_invite.id, invited: invited_user, token: "invalid")
            expect(form.decline).to eq(false)
            expect(valid_invite.reload).to be_pending
          end
        end
      end

      describe "destroy" do
        it "destroys the invite" do
          form = described_class.new(invite_id: valid_invite.id, invited: invited_user, token: token)
          expect(form.destroy).to eq(true)
          expect(::Permits::Invite.find_by(id: valid_invite.id).ended_at).to_not be_nil
        end

        it "destroys the invite's permissions" do
          group = create(:group)
          permission = create(:permission, resource: group, permits: :edit, owner: valid_invite)
          valid_invite.permissions << permission

          expect(valid_invite.permissions).to_not be_empty
          form = described_class.new(invite_id: valid_invite.id, invited: invited_user, token: token)

          expect(form.destroy).to eq(true)
          expect(permission.reload.ended_at).to_not be_nil
        end
      end
    end
  end
end
