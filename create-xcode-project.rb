#!/usr/bin/env ruby

# Blue Wave Radio - Xcode Project Generator
# This script creates a proper Xcode project with all source files

require 'fileutils'
require 'securerandom'

puts ""
puts "🎵 Blue Wave Radio - Xcode Project Generator"
puts "============================================="
puts ""

# Get current directory
project_dir = File.dirname(__FILE__)
Dir.chdir(project_dir)

puts "📁 Project directory: #{project_dir}"
puts ""

# Find all Swift files
swift_files = Dir.glob("BlueWaveRadio/**/*.swift").sort

if swift_files.empty?
  puts "❌ Error: No Swift files found in BlueWaveRadio folder"
  puts "Make sure you're running this in the correct directory"
  exit 1
end

puts "✓ Found #{swift_files.length} Swift files"
puts ""

# Generate UUIDs for each file
file_refs = {}
build_files = {}

swift_files.each do |file|
  file_refs[file] = SecureRandom.uuid.gsub('-', '').upcase[0..23]
  build_files[file] = SecureRandom.uuid.gsub('-', '').upcase[0..23]
end

# Additional UUIDs
project_uuid = SecureRandom.uuid.gsub('-', '').upcase[0..23]
target_uuid = SecureRandom.uuid.gsub('-', '').upcase[0..23]
sources_phase = SecureRandom.uuid.gsub('-', '').upcase[0..23]
frameworks_phase = SecureRandom.uuid.gsub('-', '').upcase[0..23]
resources_phase = SecureRandom.uuid.gsub('-', '').upcase[0..23]
app_ref = SecureRandom.uuid.gsub('-', '').upcase[0..23]
root_group = SecureRandom.uuid.gsub('-', '').upcase[0..23]
products_group = SecureRandom.uuid.gsub('-', '').upcase[0..23]
main_group = SecureRandom.uuid.gsub('-', '').upcase[0..23]
debug_config = SecureRandom.uuid.gsub('-', '').upcase[0..23]
release_config = SecureRandom.uuid.gsub('-', '').upcase[0..23]
build_config_list = SecureRandom.uuid.gsub('-', '').upcase[0..23]
project_config_list = SecureRandom.uuid.gsub('-', '').upcase[0..23]

puts "🔨 Generating project.pbxproj..."

# Create project content
project_content = <<~PBXPROJ
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
PBXPROJ

# Add build files
swift_files.each do |file|
  filename = File.basename(file)
  project_content += "\t\t#{build_files[file]} /* #{filename} in Sources */ = {isa = PBXBuildFile; fileRef = #{file_refs[file]} /* #{filename} */; };\n"
end

project_content += <<~PBXPROJ
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
\t\t#{app_ref} /* BlueWaveRadio.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = BlueWaveRadio.app; sourceTree = BUILT_PRODUCTS_DIR; };
PBXPROJ

# Add file references
swift_files.each do |file|
  filename = File.basename(file)
  # Remove "BlueWaveRadio/" prefix to make path relative to the group
  relative_path = file.sub(/^BlueWaveRadio\//, '')
  project_content += "\t\t#{file_refs[file]} /* #{filename} */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = \"#{relative_path}\"; sourceTree = \"<group>\"; };\n"
end

project_content += <<~PBXPROJ
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
\t\t#{frameworks_phase} /* Frameworks */ = {
\t\t\tisa = PBXFrameworksBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
\t\t#{root_group} /* Root */ = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t#{main_group} /* BlueWaveRadio */,
\t\t\t\t#{products_group} /* Products */,
\t\t\t);
\t\t\tsourceTree = "<group>";
\t\t};
\t\t#{products_group} /* Products */ = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t#{app_ref} /* BlueWaveRadio.app */,
\t\t\t);
\t\t\tname = Products;
\t\t\tsourceTree = "<group>";
\t\t};
\t\t#{main_group} /* BlueWaveRadio */ = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
PBXPROJ

# Add all files to the group
swift_files.each do |file|
  filename = File.basename(file)
  project_content += "\t\t\t\t#{file_refs[file]} /* #{filename} */,\n"
end

project_content += <<~PBXPROJ
\t\t\t);
\t\t\tpath = BlueWaveRadio;
\t\t\tsourceTree = "<group>";
\t\t};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
\t\t#{target_uuid} /* BlueWaveRadio */ = {
\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = #{build_config_list} /* Build configuration list for PBXNativeTarget "BlueWaveRadio" */;
\t\t\tbuildPhases = (
\t\t\t\t#{sources_phase} /* Sources */,
\t\t\t\t#{frameworks_phase} /* Frameworks */,
\t\t\t);
\t\t\tbuildRules = (
\t\t\t);
\t\t\tdependencies = (
\t\t\t);
\t\t\tname = BlueWaveRadio;
\t\t\tproductName = BlueWaveRadio;
\t\t\tproductReference = #{app_ref} /* BlueWaveRadio.app */;
\t\t\tproductType = "com.apple.product-type.application";
\t\t};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
\t\t#{project_uuid} /* Project object */ = {
\t\t\tisa = PBXProject;
\t\t\tattributes = {
\t\t\t\tBuildIndependentTargetsInParallel = 1;
\t\t\t\tLastSwiftUpdateCheck = 1500;
\t\t\t\tLastUpgradeCheck = 1500;
\t\t\t};
\t\t\tbuildConfigurationList = #{project_config_list} /* Build configuration list for PBXProject "BlueWaveRadio" */;
\t\t\tcompatibilityVersion = "Xcode 14.0";
\t\t\tdevelopmentRegion = en;
\t\t\thasScannedForEncodings = 0;
\t\t\tknownRegions = (
\t\t\t\ten,
\t\t\t\tBase,
\t\t\t);
\t\t\tmainGroup = #{root_group};
\t\t\tproductRefGroup = #{products_group} /* Products */;
\t\t\tprojectDirPath = "";
\t\t\tprojectRoot = "";
\t\t\ttargets = (
\t\t\t\t#{target_uuid} /* BlueWaveRadio */,
\t\t\t);
\t\t};
/* End PBXProject section */

/* Begin PBXSourcesBuildPhase section */
\t\t#{sources_phase} /* Sources */ = {
\t\t\tisa = PBXSourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
PBXPROJ

# Add all source files to build phase
swift_files.each do |file|
  filename = File.basename(file)
  project_content += "\t\t\t\t#{build_files[file]} /* #{filename} in Sources */,\n"
end

project_content += <<~PBXPROJ
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
\t\t#{debug_config} /* Debug */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tENABLE_PREVIEWS = YES;
\t\t\t\tGENERATE_INFOPLIST_FILE = NO;
\t\t\t\tINFOPLIST_FILE = BlueWaveRadio/Info.plist;
\t\t\t\tINFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
\t\t\t\tINFOPLIST_KEY_UILaunchScreen_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (
\t\t\t\t\t"$(inherited)",
\t\t\t\t\t"@executable_path/Frameworks",
\t\t\t\t);
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.bluewaveradio.BlueWaveRadio;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 6.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t};
\t\t\tname = Debug;
\t\t};
\t\t#{release_config} /* Release */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tENABLE_PREVIEWS = YES;
\t\t\t\tGENERATE_INFOPLIST_FILE = NO;
\t\t\t\tINFOPLIST_FILE = BlueWaveRadio/Info.plist;
\t\t\t\tINFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
\t\t\t\tINFOPLIST_KEY_UILaunchScreen_Generation = YES;
\t\t\t\tINFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (
\t\t\t\t\t"$(inherited)",
\t\t\t\t\t"@executable_path/Frameworks",
\t\t\t\t);
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.bluewaveradio.BlueWaveRadio;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 6.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t\tVALIDATE_PRODUCT = YES;
\t\t\t};
\t\t\tname = Release;
\t\t};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
\t\t#{build_config_list} /* Build configuration list for PBXNativeTarget "BlueWaveRadio" */ = {
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t#{debug_config} /* Debug */,
\t\t\t\t#{release_config} /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t};
\t\t#{project_config_list} /* Build configuration list for PBXProject "BlueWaveRadio" */ = {
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t#{debug_config} /* Debug */,
\t\t\t\t#{release_config} /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t};
/* End XCConfigurationList section */
\t};
\trootObject = #{project_uuid} /* Project object */;
}
PBXPROJ

# Create project directory
FileUtils.mkdir_p('BlueWaveRadio.xcodeproj')

# Write project file
File.write('BlueWaveRadio.xcodeproj/project.pbxproj', project_content)

puts "✓ Created project.pbxproj"
puts ""
puts "✅ Xcode project generated successfully!"
puts ""
puts "🎯 Next Steps:"
puts "1. Double-click: BlueWaveRadio.xcodeproj"
puts "2. Xcode will open the project"
puts "3. Select your Team in Signing & Capabilities"
puts "4. Add Background Modes capability (Audio)"
puts "5. Press ⌘+R to build and run!"
puts ""
