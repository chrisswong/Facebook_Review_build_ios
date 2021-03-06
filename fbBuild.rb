#!/usr/bin/env ruby
# fbBuild.rb
# Reference from : http://mgrebenets.github.io/xcode/2014/05/29/share-xcode-schemes/

# workspace build
#xcodebuild -arch i386 -sdk iphonesimulator8.1 -workspace iRunForLove.xcworkspace -scheme iRunForLove -configuration "Release"

#project build 
#xcodebuild -arch i386 -sdk iphonesimulator{version} 

require 'optparse'
require 'ostruct'
require 'rubygems'
require 'xcodeproj'
require 'colorize'
require 'fileutils'

# Option parser
class OptionParser

    # Parse options
    # @param [Array<String>] args command line args
    # @return [OpenStruct] parsed options
    def self.parse(args)
        options = OpenStruct.new
        options.project = nil
        options.simulator = nil

        opt_parser = OptionParser.new do |opts|

            opts.banner = "Usage: #{File.basename($0)} [options]"

            opts.separator("")
            opts.on('-p [PROJECT]', '--project [PROJECT]', "Xcode project path. Automatically look up if not provided.") do |project|
                options.project = project
            end

            opts.separator("")
            opts.separator("Help:")
            opts.on_tail('-h', '--help', 'Display this help') do
                puts opts
                exit
            end

        end

        opt_parser.parse!(args)
        options
    end # parse()
end

options = OptionParser.parse(ARGV)

# Lookup for Xcode project other than Pods
# @return [String] name of Xcode project or nil if not found
def lookup_project
    puts "Looking for Xcode project..."
    # list all .xcodeproj files except Pods
    projects_list = Dir.entries(".").select { |f| (f.end_with? ".xcodeproj") && (f != "Pods.xcodeproj") }
    projects_list.empty? ? nil : projects_list.first
end

# lookup if not specificed
options.project = lookup_project if !options.project
if !options.project then
    puts "Error".red.underline + ": No Xcode projects found in the working folder"
    exit 1
end

puts "Using project path: " + "#{options.project}".green

# Xcodeproj::Project::Object::PBXNativeTarget
xcproj = Xcodeproj::Project.open(options.project)
puts xcproj.targets
simulator = `xcodebuild -showsdks | grep iphonesimulator | tail -n 1`
if simulator.length > 0 
    index = simulator.index('iphonesimulator')
    options.simulator = simulator[index..simulator.length]
else
    puts "No ios simulator found"
end
puts "Using simulator: " + "#{options.simulator}".green

build_dir = Dir.pwd + "/build"

if Dir.exists?(build_dir)
    # puts build_dir
    cleanBuildDir = `rm -rf ${build_dir}`
end

puts build_dir 


#start build with xcodebuild
#Reference : https://developers.facebook.com/docs/ios/creating-ios-simulator-build-for-review
cmd = `xcodebuild -arch i386 -sdk #{options.simulator} OBJROOT="${build_dir}" SYMROOT="${build_dir}"`
puts cmd

#should get the product name from xcodeproj
app_path = build_dir + "/Release-iphonesimulator/helloWorld.app"
puts app_path

zip_cmd = `zip -r helloWorld_fb.app.zip #{app_path}`
puts zip_cmd

# move_zip_cmd = `mv #{build_dir}/Release-iphonesimulator/helloWorld_fb.zip #{Dir.pwd}`





