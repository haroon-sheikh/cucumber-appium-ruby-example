module Helpers
  def stub_env(setting, value)
    allow(ENV).to receive(:[]).with(setting).and_return(value)
  end

  def build_yaml_file(folder, file_name)
    File.join(File.dirname(__FILE__), "../#{folder}/#{file_name}.yml")
  end
end
