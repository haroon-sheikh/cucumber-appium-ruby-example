require 'rspec'

require_relative '../helpers/spec_helper'
require_relative '../../features/properties/run_properties'
require_relative '../../features/support/drivers/ios_driver'
require_relative '../../features/properties/ios_devices'

describe IosDriver do
  let(:ipa) { 'my_example.apk' }
  let(:instance) { Class.new(IosDriver).instance }
  let(:configuration) { { props: {}, location: location, port: port, device: device } }
  let(:port) { 1234 }
  let(:capabilities) { instance.create_driver(configuration) }

  shared_examples 'a prop using test' do
    subject { capabilities[:caps][:app] }

    before do
      configuration[:execution_device] = execution_device
      configuration[:props] = YAML.load_file(build_yaml_file('test_data', 'props'))
    end

    it { is_expected.to eql app }
  end

  shared_examples 'a local execution' do
    describe 'simulator' do
      let(:execution_device) { RunProperties::SIMULATOR }
      let(:app) { 'http://localhost:8080/ios-simulator-build.zip' }

      it_behaves_like 'a prop using test'
    end

    describe 'device' do
      let(:execution_device) { RunProperties::DEVICE }
      let(:app) { 'http://localhost:8080/ios-device-build.zip' }

      it_behaves_like 'a prop using test'
    end
  end

  shared_examples 'an external execution' do
    describe 'simulator' do
      let(:execution_device) { RunProperties::SIMULATOR }
      let(:app) { 'http://99.99.99.99:8080/ios-simulator-build.zip' }

      it_behaves_like 'a prop using test'
    end

    describe 'device' do
      let(:execution_device) { RunProperties::DEVICE }
      let(:app) { 'http://99.99.99.99:8080/ios-device-build.zip' }

      it_behaves_like 'a prop using test'
    end
  end

  context 'application in ENV' do
    let(:location) { RunProperties::APP }
    describe 'iPhone' do
      let(:device) { IosDevices::IPHONE }
      subject { capabilities[:caps][:device] }

      it { is_expected.to eql device }
    end

    describe 'iPad' do
      let(:device) { IosDevices::IPAD }
      subject { capabilities[:caps][:device] }

      it { is_expected.to eql device }
    end
  end

  context 'local execution' do
    let(:location) { RunProperties::LOCAL }

    context 'ipad' do
      let(:device) { IosDevices::IPAD }

      it_behaves_like 'a local execution'
    end

    context 'iphone' do
      let(:device) { IosDevices::IPHONE }

      it_behaves_like 'a local execution'
    end
  end

  context 'external execution' do
    let(:location) { RunProperties::EXTERNAL }

    context 'ipad' do
      let(:device) { IosDevices::IPAD }

      it_behaves_like 'an external execution'
    end

    context 'iphone' do
      let(:device) { IosDevices::IPHONE }

      it_behaves_like 'an external execution'
    end
  end
end
