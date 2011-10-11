#!/usr/bin/env ruby

module System
	class << self
		#	determine if running on genepi or dev.sph or ....
		#	genepi1 is 'n1'
		def current
			`hostname`.chomp
		end
		def apps_root
			case System.current
				when 'n1'
					'/my/ruby'
				when 'dev.sph.berkeley.edu'
					'/Users/jakewendt/github_repo/ccls'
				else 
					raise "I don't know which system that I am on and cannot continue."
			end
		end
		def environment
			ENV['RAILS_ENV'] ||= 'production'
		end
	end
end


class App
	attr_accessor :name, :pid, :status, :port
	def initialize(name)
		self.name = name
		self.pid  = get_pid
		self.status = set_status
		self.port   = set_port
	end
	def start
		if running?
			puts "Skipping #{name} start as is already running."
		else
			puts "Starting #{name} with ..."
			puts "cd #{System.apps_root}/#{name}; script/server -d -e #{System.environment} -p #{port}"
			puts `cd #{System.apps_root}/#{name}; script/server -d -e #{System.environment} -p #{port}`

#			puts `cd /my/ruby/#{name}; script/server -d -e production -p #{port}`
			#	script/server --daemon --environment=production --port=########
			#		OR
			#	script/server -d -e production -p ########
		end
	end
	def stop
		if running?
			puts "Stopping #{name}"
			Process.kill(9,pid.to_i) 
			self.pid = nil
			self.status = 'Not Running'
			File.delete(pid_file)
		else
			puts "Skipping #{name} stop as is not running."
		end
	end
	def restart
		puts "Restarting #{name}"
		self.stop
		self.start
	end
	def running?
		status == 'Running'
	end
protected
	def pid_file
		"#{System.apps_root}/#{name}/tmp/pids/server.pid"
	end
	def get_pid
		self.pid = if File.exists?(pid_file)
			IO.read(pid_file)
		else
			nil
		end
	end
	def set_status
		self.status = case
			when pid.nil? then 'Not Running'
			when (( `ps #{pid} | grep -vs 'PID'` ) !~ /\S/ ) then 'Missing'
			else 'Running'
		end
	end
	def set_port
		self.port = case name
			when 'homex'     then 3000
			when 'odms'      then 3001
			when 'abstracts' then 3002
			else 
				puts "Unknown app name:#{name}:"
				exit 1
		end
	end
end

##################################################


#	add option parsing so user can pass ...
#		rails environment 
#		dry run
#		...






all_apps = %w( abstracts homex odms )
command = ARGV.shift

unless( other_apps = ( ARGV - all_apps ) ).empty?
	puts "App(s) #{other_apps.join(', ')} is/are unknown."
	exit 1
end

apps = (( ARGV.empty? ) ? all_apps : ARGV).collect{|app|App.new(app)}

case command
	when /^star.*/
		apps.each { |app| app.start }
	when /^sto.*/
		apps.each { |app| app.stop }
	when /^stat.*/ 
		puts "System:   #{System.current}"
		puts "AppsRoot: #{System.apps_root}"
		printf "%-15s %-15s %10s %6s\n", 'NAME', 'STATUS', 'PID', 'PORT'
		apps.each { |app| printf "%-15s %-15s %10s %6s\n", app.name, app.status, app.pid, app.port }
	when /^r.*/
		apps.each { |app| app.restart }
	else puts "Confused? #{command}? Expected {start|stop|restart|status}"
end

__END__

from /usr/lib/ruby/user-gems/1.8/gems/rails-2.3.12/lib/commands/server.rb


require 'optparse'

options = {
  :Port        => 3000,
  :Host        => "0.0.0.0",
  :environment => (ENV['RAILS_ENV'] || "development").dup,
  :config      => RAILS_ROOT + "/config.ru",
  :detach      => false,
  :debugger    => false,
  :path        => nil
}

ARGV.clone.options do |opts|
  opts.on("-p", "--port=port", Integer,
          "Runs Rails on the specified port.", "Default: 3000") { |v| options[:Port] = v }
  opts.on("-b", "--binding=ip", String,
          "Binds Rails to the specified ip.", "Default: 0.0.0.0") { |v| options[:Host] = v }
  opts.on("-c", "--config=file", String,
          "Use custom rackup configuration file") { |v| options[:config] = v }
  opts.on("-d", "--daemon", "Make server run as a Daemon.") { options[:detach] = true }
  opts.on("-u", "--debugger", "Enable ruby-debugging for the server.") { options[:debugger] = true }
  opts.on("-e", "--environment=name", String,
          "Specifies the environment to run this server under (test/development/production).",
          "Default: development") { |v| options[:environment] = v }
  opts.on("-P", "--path=/path", String, "Runs Rails app mounted at a specific path.", "Default: /") { |v| options[:path] = v }

  opts.separator ""

  opts.on("-h", "--help", "Show this help message.") { puts opts; exit }

  opts.parse!
end


