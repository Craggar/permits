module Permits
  module Policy
    describe Base, type: :model do
      let(:user) { create(:user) }
      let(:resource) { create(:group) }
      let(:user_permission_level) { :read }
      let(:check_level) { :read }
      let!(:permission) { create(:permission, owner: user, resource: resource, permits: user_permission_level) }

      describe "class methods" do
        describe ".authorize!" do
          let(:subject) { described_class.authorize!(user, resource, check_level) }

          context "when the user is approved at the requested level" do
            it { is_expected.to be true }
          end

          context "when the user is not approved at the requested level" do
            let(:check_level) { :edit }

            it "raises an UnauthorizedError" do
              expect { subject }.to raise_error(Permits::Policy::UnauthorizedError)
            end
          end

          context "when the user is approved at some level and the check is for any" do
            let(:check_level) { :any }

            it { is_expected.to be true }
          end

          context "when the user is not approved at any level" do
            let!(:permission) { nil }

            it "raises an UnauthorizedError" do
              expect { subject }.to raise_error(Permits::Policy::UnauthorizedError)
            end
          end

          context "when the level is not valid" do
            let(:check_level) { :invalid }

            it "raises an UnauthorizedError" do
              expect { subject }.to raise_error(Permits::Policy::UnauthorizedError)
            end
          end
        end

        describe ".authorized?" do
          let(:subject) { described_class.authorized?(user, resource, check_level) }

          context "when the user is approved at the requested level" do
            it { is_expected.to be true }
          end

          context "when the user is not approved at the requested level" do
            let(:check_level) { :edit }

            it { is_expected.to be false }
          end

          context "when the user is approved at some level and the check is for any" do
            let(:check_level) { :any }

            it { is_expected.to be true }
          end

          context "when the user is not approved at any level" do
            let!(:permission) { nil }

            it { is_expected.to be false }
          end

          context "when the level is not valid" do
            let(:check_level) { :invalid }

            it { is_expected.to be false }
          end
        end
      end

      describe "instance methods" do
        let(:policy) { described_class.new(owner: user, resource: resource) }
        describe "#authorized?" do
          let(:subject) { policy.authorized?(check_level) }

          context "when the user is approved at the requested level" do
            it { is_expected.to be true }
          end

          context "when the user is not approved at the requested level" do
            let(:check_level) { :edit }

            it { is_expected.to be false }
          end

          context "when the user is approved at some level and the check is for any" do
            let(:check_level) { :any }

            it { is_expected.to be true }
          end

          context "when the user is not approved at any level" do
            let!(:permission) { nil }

            it { is_expected.to be false }
          end

          context "when the level is not valid" do
            let(:check_level) { :invalid }

            it { is_expected.to be false }
          end
        end

        describe "has_action_permissions?" do
          context "default behavior (checks resource)" do
            let(:subject) { policy.has_action_permissions?(check_level) }

            it { is_expected.to be true }
          end

          context "when passed a for_resource param" do
            let(:subject) { policy.has_action_permissions?(check_level, for_resource: resource) }

            it { is_expected.to be true }
          end

          context "when passed a for_resource_type and for_resource_id param" do
            let(:subject) { policy.has_action_permissions?(check_level, for_resource_type: resource.class.name, for_resource_id: resource.id) }

            it { is_expected.to be true }
          end
        end
      end
    end
  end
end
