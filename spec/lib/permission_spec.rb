module Permits
  describe Permission, type: :model do
    it { should belong_to(:owner) }
    it { should belong_to(:resource) }

    describe "scopes" do
      let!(:super_user_permission) { create(:permission, :super_user) }
      let!(:read_permission) { create(:permission, :read) }
      let!(:edit_permission) { create(:permission, :edit) }
      let!(:create_permission) { create(:permission, :create) }
      let!(:destroy_permission) { create(:permission, :destroy) }

      before do
        expect(Permission.count).to eq(5)
      end

      describe ".permits_super_user" do
        it "returns permissions with permits set to Permission::SUPER_USER" do
          expect(Permission.permits_super_user.count).to eq(1)
          expect(Permission.permits_super_user).to match_array([super_user_permission])
        end
      end

      describe ".permits_read" do
        it "returns permissions with permits set to Permission::READ" do
          expect(Permission.permits_read.count).to eq(1)
          expect(Permission.permits_read).to match_array([read_permission])
        end
      end

      describe ".permits_edit" do
        it "returns permissions with permits set to Permission::EDIT" do
          expect(Permission.permits_edit.count).to eq(1)
          expect(Permission.permits_edit).to match_array([edit_permission])
        end
      end

      describe ".permits_create" do
        it "returns permissions with permits set to Permission::CREATE" do
          expect(Permission.permits_create.count).to eq(1)
          expect(Permission.permits_create).to match_array([create_permission])
        end
      end

      describe ".permits_destroy" do
        it "returns permissions with permits set to Permission::DESTROY" do
          expect(Permission.permits_destroy.count).to eq(1)
          expect(Permission.permits_destroy).to match_array([destroy_permission])
        end
      end
    end
  end
end
