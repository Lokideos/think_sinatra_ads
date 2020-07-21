# frozen_string_literal: true

RSpec.describe Ads::GeocodingService do
  subject { described_class }
  let(:ad) { create(:ad) }

  let(:id) { ad.id }
  let(:city) { ad.city }
  let(:coordinates) { [10.0, 10.0] }
  let(:geocoder_client) { double('Geocoder Client') }

  before do
    allow(GeocodeService::Client).to receive(:new).and_return(geocoder_client)
  end

  describe '#call' do
    context 'city is present in geocoding service' do
      before do
        allow(geocoder_client).to receive(:geocode).with(ad: ad.values).and_return(coordinates)
      end

      it 'should correctly update ad lon' do
        subject.call(ad.values)

        expect(ad.reload.lon).to eq coordinates[0]
      end

      it 'should correctly update ad lat' do
        subject.call(ad.values)

        expect(ad.reload.lat).to eq coordinates[1]
      end
    end

    context 'city is not present in geocoding service' do
      before do
        allow(geocoder_client).to receive(:geocode).with(ad: ad.values).and_return(nil)
      end

      it 'should not update ad lon' do
        subject.call(ad.values)

        expect(ad.reload.lon).to be_nil
      end

      it 'should not update ad lat' do
        subject.call(ad.values)

        expect(ad.reload.lat).to be_nil
      end
    end
  end
end
