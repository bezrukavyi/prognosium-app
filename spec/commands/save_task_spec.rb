describe SaveTask, type: :command do
  let(:task) { create :task }
  let(:params) do
    { task: attributes_for(:task),
      file: fixture_file_upload('/files/test.xlsx') }
  end

  describe '#call' do
    subject { SaveTask.new(task, params) }

    context 'when valid' do
      it 'set valid broadcast' do
        expect { subject.call }.to broadcast(:valid)
      end
      it 'update initial_data of task' do
        expect { subject.call }.to change { task.initial_data }
      end
      it 'dont update initial_data when file empty' do
        subject.call
        params[:file] = nil
        expect { SaveTask.call(task, params) }
          .not_to change { task.initial_data }
      end
    end

    it 'invalid' do
      task.title = nil
      subject = SaveTask.new(task, params)
      expect { subject.call }.to broadcast(:invalid)
    end

    it 'invalid_file' do
      params[:file] = fixture_file_upload('/files/test.txt')
      subject = SaveTask.new(task, params)
      expect { subject.call }.to broadcast(:invalid_file)
    end
  end
end
