#!/usr/bin/env ruby


class App
	attr_accessor :name, :pid, :status
	def initialize(name)
		self.name = name
		self.pid  = get_pid
		self.status = set_status
	end
	def start
		puts "Starting #{name}"
#	cd /my/ruby/app.name
#	script/server --daemon --environment=production --port=########
#		OR
#	script/server -d -e production -p ########
	end
	def stop
		puts "Stopping #{name}"
#		Process.kill(9,pid)
	end
	def restart
		puts "Restarting #{name}"
		self.stop if status == 'Running'
		self.start
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
end

all_apps = %w( abstracts homex odms )
command = ARGV.shift
apps = (( ARGV.empty? ) ? all_apps : ARGV).collect{|app|App.new(app)}

case command
	when /^star.*/
#	loop through each app
#		ensure not running
#		if any running
#			exit
#		else
#			start each app
		apps.each { |app| app.start }
	when /^sto.*/
		apps.each { |app| app.stop }
	when /^stat.*/ 
		apps.each { |app| printf "%-15s %s\n", app.name, app.status }
	when /^r.*/
#	loop through each app
#		if running
#			stop
#		start app
		apps.each { |app| app.restart }
	else puts "Confused? #{command}? Expected {start|stop|restart|status}"
end
