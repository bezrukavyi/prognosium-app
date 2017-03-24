describe ParseSheetService, type: :service do
  let(:file) { fixture_file_upload('/files/test.xlsx') }
  subject { ParseSheetService.call(file, :json) }

  describe '.call' do
    before do
      @result = JSON.parse(subject)
    end
    it 'return json' do
      expect(@result).not_to be_blank
    end
    it 'have date_title' do
      expect(@result['date_title']).not_to be_nil
    end
    it 'have value_title' do
      expect(@result['value_title']).not_to be_nil
    end
    it 'have values' do
      expect(@result['values'].values.count).not_to be_zero
    end
  end

  describe '#valid?' do
    it 'true' do
      subject = ParseSheetService.new(file, :json)
      expect(subject.valid?).to be_truthy
    end
    it 'false' do
      file = fixture_file_upload('/files/test.txt')
      subject = ParseSheetService.new(file, :json)
      expect(subject.valid?).to be_falsey
    end
  end

  it '#file_extname' do
    expect(ParseSheetService.new(file, :json).file_extname).to eq('xlsx')
  end
end
