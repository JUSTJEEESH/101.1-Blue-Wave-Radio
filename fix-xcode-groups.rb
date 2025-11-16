#!/usr/bin/env ruby

require 'fileutils'
require 'securerandom'

puts "🔧 Fixing Xcode project group structure..."

# Remove old project
FileUtils.rm_rf('BlueWaveRadio.xcodeproj')

# Run the original script
system('ruby create-xcode-project.rb')

puts "✅ Project regenerated with correct structure!"
