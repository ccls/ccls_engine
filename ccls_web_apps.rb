#!/usr/bin/env ruby


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
			puts "Starting #{name}"
			puts `cd /my/ruby/#{name}; script/server -d -e development -p #{port}`
			#	script/server --daemon --environment=production --port=########
			#		OR
			#	script/server -d -e production -p ########
		end
	end
	def stop
		if running?
			puts "Stopping #{name}"
			Process.kill(9,pid.to_i) 
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
	def get_pid
		self.pid = if File.exists?("#{name}/tmp/pids/server.pid")
			IO.read("#{name}/tmp/pids/server.pid")
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
		printf "%-15s %-15s %10s %6s\n", 'NAME', 'STATUS', 'PID', 'PORT'
		apps.each { |app| printf "%-15s %-15s %10s %6s\n", app.name, app.status, app.pid, app.port }
	when /^r.*/
		apps.each { |app| app.restart }
	else puts "Confused? #{command}? Expected {start|stop|restart|status}"
end
