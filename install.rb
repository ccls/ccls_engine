#!/usr/bin/env ruby

File.open(File.join(RAILS_ROOT,'config','preinitializer.rb'),
	File::WRONLY|File::APPEND|File::CREAT) do |f|

f.puts <<-end_file
Dir.glob(
	File.join(RAILS_ROOT,'lib/plugins/*/preinitializer.rb')
) + Dir.glob(
	File.join(RAILS_ROOT,'{lib,vendor}/plugins/*/rails/preinitializer.rb')
).each do |preinitializer|
	require(preinitializer)
end
end_file

end
