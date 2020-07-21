# frozen_string_literal: true

RSpec.describe GeocodeService::Client, type: :client do
  subject { described_class.new(connection: connection) }

  let(:status) { 200 }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:body) { {} }

  before do
    stubs.post('geocode') { [status, headers, body.to_json] }
  end

  describe '#geocode (city exists)' do
    let(:ad_id) { 1 }
    let(:coordinates) { [10.0, 10.0] }
    let(:body) { { 'ad_id' => ad_id, 'coordinates' => { 'coordinates' => coordinates } } }

    it 'returns coordinates' do
      expect(subject.geocode('correct_ad')).to eq coordinates
    end
  end

  describe '#geocode (city does not exist)' do
    let(:status) { 404 }

    it 'returns a nil value' do
      expect(subject.geocode('invalid_ad')).to be_nil
    end
  end
end
