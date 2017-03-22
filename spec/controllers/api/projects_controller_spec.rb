include Support::Auth

describe Api::ProjectsController, type: :controller do
  let(:user) { create :user }

  before do
    @project = create :project, user: user
    @another_project = create :project
    auth_request user
  end

  describe 'GET #index' do
    before do
      get :index
    end
    it 'get all projects' do
      expect(assigns(:projects)).to eq([@project])
    end
    it 'returns a successful 200 response' do
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it 'returns a successful 200 response' do
      get :show, params: { id: @project.id }
      expect(response).to be_success
    end

    it 'returns data of an single project' do
      get :show, params: { id: @project.id }
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).not_to be_blank
    end

    it 'returns an error if the project does not exist' do
      get :show, params: { id: 100 }
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).not_to be_blank
      expect(response).to be_not_found
    end

    it 'returns an error if the project does not belongs to user' do
      get :show, params: { id: @another_project.id }
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error'])
        .to eq('You are not authorized to access this page.')
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { project: attributes_for(:project) } }

    it 'returns a successful 200 response' do
      post :create, params: valid_params
      expect(response).to be_success
    end
    it 'create new project' do
      expect { post :create, params: valid_params }
        .to change { Project.count }.by(1)
    end
    it 'when data invalid' do
      post :create, params: { project: attributes_for(:project, :invalid) }
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).not_to be_blank
    end
  end

  describe 'PATCH #update' do
    let(:valid_params) do
      { id: @project.id, project: attributes_for(:project, title: 'New title') }
    end

    it 'returns a successful 200 response' do
      patch :update, params: valid_params
      expect(response).to be_success
    end
    it 'updaet project' do
      expect { patch :update, params: valid_params }
        .to change { @project.reload.attributes }
    end
    it 'when data invalid' do
      patch :update, params: { id: @project.id,
                               project: attributes_for(:project, :invalid) }

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).not_to be_blank
    end
  end

  describe 'DELETE #destroy' do
    it 'returns a successful 200 response' do
      delete :destroy, params: { id: @project.id }
      expect(response).to be_success
    end
    it 'updaet project' do
      expect { delete :destroy, params: { id: @project.id } }
        .to change { Project.count }.by(-1)
    end
    it 'when data invalid' do
      delete :destroy, params: { id: 100 }
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).not_to be_blank
    end
  end
end
