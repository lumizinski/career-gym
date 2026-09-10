require "rails_helper"

RSpec.describe "Training", type: :request do
  describe "GET /training" do
    it "requires authentication" do
      get training_index_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it "allows authenticated users to access training" do
      user = create(:user)

      sign_in user
      get training_index_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Training Plan")
    end

    it "shows only the signed-in user's training plan" do
      viewer = create(:user)
      other_user = create(:user)
      viewer_item = create(:training_item, training_plan: create(:training_plan, user: viewer), title: "Viewer training")
      create(:training_item, training_plan: create(:training_plan, user: other_user), title: "Other training")

      sign_in viewer
      get training_index_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(viewer_item.title)
      expect(response.body).not_to include("Other training")
    end
  end

  describe "PATCH /training_items/:id" do
    it "prevents modifying another user's training item" do
      owner = create(:user)
      intruder = create(:user)
      item = create(:training_item, training_plan: create(:training_plan, user: owner))

      sign_in intruder
      patch training_item_path(item), params: { training_item: { status: :completed } }

      expect(response).to have_http_status(:not_found)
      expect(item.reload).to be_pending
    end

    it "updates status to completed" do
      user = create(:user)
      item = create(:training_item, training_plan: create(:training_plan, user: user), status: :in_progress)

      sign_in user
      patch training_item_path(item), params: { training_item: { status: :completed } }

      expect(response).to redirect_to(training_index_path)
      expect(item.reload).to be_completed
    end

    it "redirects back to weekly focus when completion is triggered there" do
      user = create(:user)
      item = create(:training_item, training_plan: create(:training_plan, user: user), status: :in_progress)

      sign_in user
      patch training_item_path(item), params: { training_item: { status: :completed }, return_to: focus_path }

      expect(response).to redirect_to(focus_path)
      expect(item.reload).to be_completed
    end

    it "ignores unsafe return_to values" do
      user = create(:user)
      item = create(:training_item, training_plan: create(:training_plan, user: user), status: :in_progress)

      sign_in user
      patch training_item_path(item), params: { training_item: { status: :completed }, return_to: "https://evil.example/phish" }

      expect(response).to redirect_to(training_index_path)
      expect(item.reload).to be_completed
    end

    it "updates status to in progress" do
      user = create(:user)
      item = create(:training_item, training_plan: create(:training_plan, user: user), status: :pending)

      sign_in user
      patch training_item_path(item), params: { training_item: { status: :in_progress } }

      expect(response).to redirect_to(training_index_path)
      expect(item.reload).to be_in_progress
    end
  end

  describe "POST /training" do
    it "generates a plan from prioritized skill gaps with largest gaps first" do
      user = create(:user)
      profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
      role = create(:role, title: profile.target_role)

      system_design = create(:skill, name: "System Design", category: "Architecture")
      distributed = create(:skill, name: "Distributed Systems", category: "Architecture")
      postgres = create(:skill, name: "PostgreSQL", category: "Database")

      create(:role_skill, role: role, skill: system_design, required_level: 8, importance: "Critical")
      create(:role_skill, role: role, skill: distributed, required_level: 7, importance: "Critical")
      create(:role_skill, role: role, skill: postgres, required_level: 7, importance: "High")

      create(:user_skill, user: user, skill: system_design, level: 2, confidence: 4)
      create(:user_skill, user: user, skill: distributed, level: 3, confidence: 4)
      create(:user_skill, user: user, skill: postgres, level: 6, confidence: 7)

      sign_in user

      post training_index_path

      plan = user.reload.training_plan
      ordered_items = plan.training_items.ordered
      ordered_skills = ordered_items.map(&:skill).uniq

      expect(response).to redirect_to(training_index_path)
      expect(plan).to be_present
      expect(plan.training_items).not_to be_empty
      expect(ordered_items.first.title).to eq("Study scalability fundamentals")
      expect(ordered_skills).to eq([ system_design, distributed, postgres ])
    end
  end
end
