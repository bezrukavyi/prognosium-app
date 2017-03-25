describe UpdateTask, type: :command do
  let(:task) { create :task }
  let(:params) do
    { task: attributes_for(:task),
      file: fixture_file_upload('/files/test.xlsx') }
  end

  let(:subject) { UpdateTask.new(task, params) }

  before do
    allow(subject).to receive(:task_params).and_return(params[:task])
  end

  describe 'change_position' do
    it 'update' do
      params[:task][:position] = task.position + 1
      expect { subject.call }.to change { task.position }
    end
    it "don't update" do
      expect { subject.call }.not_to change { task.position }
    end
  end

  it 'update attributes' do
    params[:task][:title] = 'Another title'
    expect { subject.call }.to change { task.title }
  end
end
