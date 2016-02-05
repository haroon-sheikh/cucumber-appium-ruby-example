require 'rspec'

require_relative '../helpers/spec_helper'
require_relative '../../features/support/drivers/android_driver'
require_relative '../../features/properties/run_properties'

describe AndroidDriver do
  let(:package) { 'com.my.package' }
  let(:apk) { 'my_example.apk' }
  let(:port) { 1234 }
  let(:instance) { Class.new(AndroidDriver).instance }
  let(:configuration) { { package: package, props: {}, location: location, port: port } }
  let(:capabilities) { instance.create_driver(configuration) }
  let(:package_setting) { 'package' }

  shared_examples 'a package in ENV' do
    before do
      stub_env(package_setting, package)
    end

    describe 'package in capabilities' do
      subject { capabilities[:caps][:package] }

      it { is_expected.to eql package }
    end

    describe 'port' do
      subject { capabilities[:appium_lib][:port] }

      it { is_expected.to eql port }
    end

    describe 'app' do
      subject { capabilities[:caps][:app] }

      it { is_expected.to eql app }
    end
  end

  context 'with APK' do
    let(:app) { apk }
    let(:location) { RunProperties::APP }

    before do
      stub_env('apk', apk)
    end

    context 'with packagen in ENV' do
      it_behaves_like 'a package in ENV'
    end

    context 'without package in ENV' do
      let(:yaml_file) { YAML.load_file(build_yaml_file('test_data', filename)) }

      before do
        stub_env(package_setting, nil)
        expect(YAML).to receive(:load_file).with(instance_of(String)).and_return(yaml_file)
      end

      context 'package in properties' do
        let(:filename) { 'driver_with_packet' }
        let(:package) { yaml_file[:caps][:package] }
        subject { capabilities[:caps][:package] }

        it { is_expected.to eql package }
      end

      context 'no package in properties' do
        let(:filename) { 'driver_without_packet' }

        it 'is expected to fail' do
          expect { instance.create_driver(configuration) }.to raise_error(ArgumentError)
        end
      end
    end
  end

  context 'with Local Setting' do
    let(:location) { RunProperties::LOCAL }
    let(:app) { 'http://localhost:8080/path/to/your/build.apk' }

    before do
      stub_env('AppLocation', 'local')
      configuration[:props] = YAML.load_file(build_yaml_file('test_data', 'props'))
    end

    context 'with packagen in ENV' do
      it_behaves_like 'a package in ENV'
    end

    context 'without package in ENV' do
      let(:yaml_file) { YAML.load_file(build_yaml_file('test_data', filename)) }
      let(:filename) { 'driver_with_packet' }

      before do
        stub_env(package_setting, nil)
        expect(YAML).to receive(:load_file).with(instance_of(String)).and_return(yaml_file)
      end

      subject { capabilities[:caps][:app] }

      it { is_expected.to eql app }
    end
  end

  context 'with external settings' do
    let(:location) { RunProperties::EXTERNAL }
    let(:app) { 'http://99.99.99.99:8080/job/build.apk' }

    before do
      stub_env('AppLocation', 'external')
      configuration[:props] = YAML.load_file(build_yaml_file('test_data', 'props'))
    end

    context 'with packagen in ENV' do
      it_behaves_like 'a package in ENV'
    end
  end
end
