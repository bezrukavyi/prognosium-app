describe UpdateForecast, type: :command do
  let(:forecast) { create :forecast }
  let(:params) do
    { forecast: attributes_for(:forecast, :without_initial_data),
      file: fixture_file_upload('/files/new_data.xlsx') }
  end

  describe '#call' do
    subject { UpdateForecast.new(forecast, params) }

    before do
      allow(subject).to receive(:forecast_params).and_return(params[:forecast])
    end

    context 'when valid' do
      it 'set valid broadcast' do
        expect { subject.call }.to broadcast(:valid)
      end
      it 'forecast update initial_data' do
        expect { subject.call }.to change { forecast.reload.initial_data }
      end
    end

    it 'invalid' do
      params[:forecast][:alpha] = nil
      subject = UpdateForecast.new(forecast, params)
      allow(subject).to receive(:forecast_params).and_return(params[:forecast])
      expect { subject.call }.to broadcast(:invalid)
    end

    it 'invalid_file' do
      params[:file] = fixture_file_upload('/files/test.txt')
      subject = UpdateForecast.new(forecast, params)
      expect { subject.call }.to broadcast(:invalid_file)
    end
  end
end
