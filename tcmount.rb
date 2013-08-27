#!/usr/bin/env ruby

require "io/console"

TRUECRYPT = '/Applications/TrueCrypt.app/Contents/MacOS/Truecrypt'

def checkTruecrypt
  if !File.exist?(TRUECRYPT)
    puts "Truecrypt isn't installed"
    raise
  end
end

def getVolume()
  raise "Too many arguments" unless ARGV.count < 2
  ARGV[0]
end

def getPassword()
  if STDIN.respond_to?("noecho")
    print "[password]:"
    password = STDIN.noecho(&:gets).chomp
    puts ""
    password
  else
    puts "Please update your ruby version to >= 1.9"
    raise
  end
end

def mountVolume(volume, password)
  result = system("#{TRUECRYPT} --text #{volume} -p #{password} --non-interactive")
  if result
    puts "Volume has been successfully mounted"
  else
    puts "Mount failed"
    raise
  end
end

def unmountVolume()
  result = system("#{TRUECRYPT} --text -d") 
  if result
    puts "Volume has been successfully unmounted"
  else
    puts "Unmount failed"
    raise
  end
end

begin
  checkTruecrypt
  volume = getVolume
  if !volume.nil? 
    password = getPassword
    mountVolume(volume, password)
  else
    unmountVolume
  end

rescue StandardError=>error
  puts "\n#{error}\n" unless error.nil?
  exit 1
end

exit 0
