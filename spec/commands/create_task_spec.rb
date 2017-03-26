describe CreateTask, type: :command do
  let(:task) { create :task }
  let(:params) do
    { task: attributes_for(:task),
      file: fixture_file_upload('/files/test.xlsx') }
  end

  describe '#call' do
    subject { CreateTask.new(task, params) }

    context 'when valid' do
      it 'set valid broadcast' do
        expect { subject.call }.to broadcast(:valid)
      end
      context 'forecast' do
        it 'create forecast when file uploaded' do
          expect { subject.call }.to change { Forecast.count }.by(1)
        end
        it 'forecast initial_data not empty' do
          subject.call
          expect(task.forecast.initial_data).not_to be_blank
        end
      end
    end

    it 'invalid' do
      task.title = nil
      subject = CreateTask.new(task, params)
      expect { subject.call }.to broadcast(:invalid)
    end

    it 'invalid_file' do
      params[:file] = fixture_file_upload('/files/test.txt')
      subject = CreateTask.new(task, params)
      expect { subject.call }.to broadcast(:invalid_file)
    end
  end
end
