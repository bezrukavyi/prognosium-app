include Support::Auth
include Support::CanCanStub
include Support::Command
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
    let(:params) do
      { project_id: project.id,
        task: attributes_for(:task, project_id: project.id),
        file: fixture_file_upload('/files/test.xlsx') }
    end

    before do
      receive_cancan(:load_and_authorize, task: @task)
    end

    it 'SaveTask call' do
      allow(controller).to receive(:params).and_return(params)
      expect(SaveTask).to receive(:call)
      post :create, params: params
    end

    it 'success response by valid command' do
      stub_const('SaveTask', Support::Command::Valid)
      post :create, params: params
      expect(response).to be_success
    end

    it 'error by invalid command' do
      invalid_task = build :task, :invalid
      invalid_task.save
      stub_const('SaveTask', Support::Command::Invalid)
      Support::Command::Invalid.block_value = invalid_task
      post :create, params: params
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).not_to be_blank
    end

    it 'error by invalid_file command' do
      stub_const('SaveTask', Support::Command::InvalidFile)
      Support::Command::InvalidFile.block_value = 'txt'
      post :create, params: params
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).to eq I18n.t('file.invalid', value: 'txt')
    end
  end

  describe 'PATCH #update' do
    let(:params) do
      { id: @task.id, project_id: @task.project_id,
        task: attributes_for(:task, title: 'New title') }
    end

    before do
      receive_cancan(:load_and_authorize, task: @task)
    end

    it 'SaveTask call' do
      allow(controller).to receive(:params).and_return(params)
      expect(UpdateTask).to receive(:call)
      patch :update, params: params
    end

    it 'success response by valid command' do
      stub_const('UpdateTask', Support::Command::Valid)
      patch :update, params: params
      expect(response).to be_success
    end

    it 'error by invalid command' do
      invalid_task = build :task, :invalid
      invalid_task.save
      stub_const('UpdateTask', Support::Command::Invalid)
      Support::Command::Invalid.block_value = invalid_task
      patch :update, params: params
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).not_to be_blank
    end

    it 'error by invalid_file command' do
      stub_const('UpdateTask', Support::Command::InvalidFile)
      Support::Command::InvalidFile.block_value = 'txt'
      patch :update, params: params
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).to eq I18n.t('file.invalid', value: 'txt')
    end
  end

  describe 'DELETE #destroy' do
    it 'returns a successful 200 response' do
      delete :destroy, params: { id: @task.id, project_id: @task.project_id }
      expect(response).to be_success
    end
    it 'destroy task' do
      expect { delete :destroy, params: { id: @task.id, project_id: @task.project_id } }
        .to change { @tasks.reload.count }.by(-1)
    end
    it 'when data invalid' do
      delete :destroy, params: { id: 100, project_id: @task.project_id }
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).not_to be_blank
    end
  end
end
