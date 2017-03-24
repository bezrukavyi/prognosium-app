include Support::Auth
include Support::CanCanStub

describe Api::TasksController, type: :controller do
  let(:user) { create :user }
  let(:project) { create :project, :with_tasks, user: user }

  before do
    @tasks = project.tasks
    @task = @tasks.first
    auth_request user
  end

  describe 'GET #show' do
    context 'succes result' do
      before do
        get :show, params: { id: @task.id, project_id: @task.project_id }
      end
      it 'returns a successful 200 response' do
        expect(response).to be_success
      end

      it 'returns data of an single task' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).not_to be_blank
      end
    end

    it 'returns an error if the project does not exist' do
      get :show, params: { id: 100, project_id: @task.project_id }
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).not_to be_blank
      expect(response).to be_not_found
    end

    it 'returns an error if the project does not belongs to user' do
      @another_task = create :task
      get :show, params: { id: @another_task.id, project_id: @another_task.project_id }
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error'])
        .to eq('You are not authorized to access this page.')
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      { project_id: project.id, task: attributes_for(:task, project_id: project.id) }
    end

    it 'returns a successful 200 response' do
      post :create, params: valid_params
      expect(response).to be_success
    end
    it 'create new task' do
      expect { post :create, params: valid_params }
        .to change { @tasks.reload.count }.by(1)
    end
    it 'when data invalid' do
      post :create, params: { project_id: project.id,
                              task: attributes_for(:task, :invalid,
                                                   project_id: project.id) }
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).not_to be_blank
    end
  end

  describe 'PATCH #update' do
    let(:valid_params) do
      { id: @task.id, task: attributes_for(:task, title: 'New title') }
    end

    it 'returns a successful 200 response' do
      patch :update, params: valid_params
      expect(response).to be_success
    end
    it 'update task' do
      expect { patch :update, params: valid_params }
        .to change { @task.reload.attributes }
    end
    it 'when data invalid' do
      patch :update, params: { id: @task.id,
                               task: attributes_for(:task, :invalid) }

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).not_to be_blank
    end

    context 'update position' do
      before do
        receive_cancan(:load_and_authorize, task: @task)
      end
      it 'when position doesnt changed' do
        valid_params[:task][:position] = 100
        expect(@task).to receive(:set_list_position).with(100)
        patch :update, params: valid_params
      end
      it 'when position is changed' do
        valid_params[:task][:position] = @task.position
        expect(@task).not_to receive(:set_list_position)
        patch :update, params: valid_params
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'returns a successful 200 response' do
      delete :destroy, params: { id: @task.id }
      expect(response).to be_success
    end
    it 'destroy task' do
      expect { delete :destroy, params: { id: @task.id } }
        .to change { @tasks.reload.count }.by(-1)
    end
    it 'when data invalid' do
      delete :destroy, params: { id: 100 }
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).not_to be_blank
    end
  end
end
