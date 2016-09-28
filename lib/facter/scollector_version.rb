require 'facter'

Facter.add("scollector_version") do
  confine :osfamily => 'RedHat'
  setcode do
    if File.exists?("/usr/local/scollector")
      if File.executable?("/usr/local/scollector/scollector-linux-amd64")
        result = Facter::Util::Resolution.exe("/usr/local/scollector/scollector-linux-amd64 -version")
        if result
          version = result.sub(%r{^scollector\Wversion\W(\d+\.\d+\.\d+).*$},'\1')
          if version.empty? or version.nil?
            '0.unknown'
          else
            version
          end
        else
          'Scollector Output Error'
        end
      else
        'Scollector Executable Missing'
      end
    else
      'Scollector Not Installed'
    end
  end
end

Facter.add("scollector_version") do
  confine :osfamily => 'windows'
  setcode do
    if File.exists?("C:\\Program Files\\scollector")
      if File.executable?("C:\\Program Files\\scollector\\scollector-windows-amd64.exe")
        result = Facter::Util::Resolution.exe("C:\\Program Files\\scollector\\scollector-windows-amd64.exe -version")
        if result
          version = result.sub(%r{^scollector\Wversion\W(\d+\.\d+\.\d+).*$},'\1')
          if version.empty? or version.nil?
            '0.unknown'
          else
            version
          end
        else
          'Scollector Output Error'
        end
      else
        'Scollector Executable Missing'
      end
    else
      'Scollector Not Installed'
    end
  end
end
