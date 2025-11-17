#!/usr/bin/env python3
"""
Script to add missing Swift files to the Xcode project.
This fixes the "Cannot find 'WeatherManager' in scope" error.
"""

import uuid
import re

# Files that need to be added
missing_files = [
    ("WeatherManager.swift", "Services/WeatherManager.swift", "Services"),
    ("Weather.swift", "Models/Weather.swift", "Models"),
    ("WeatherWidget.swift", "Views/Components/WeatherWidget.swift", "Views/Components"),
    ("SettingsView.swift", "Views/Settings/SettingsView.swift", "Views/Settings"),
]

def generate_uuid():
    """Generate a UUID in Xcode format (uppercase, no dashes)"""
    return ''.join(str(uuid.uuid4()).upper().split('-'))[:24]

def add_files_to_project():
    project_file = "BlueWaveRadio.xcodeproj/project.pbxproj"

    try:
        with open(project_file, 'r') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"Error: Could not find {project_file}")
        return False

    # Generate UUIDs for each file
    file_refs = {}
    build_files = {}

    for filename, path, group in missing_files:
        file_refs[filename] = generate_uuid()
        build_files[filename] = generate_uuid()

    # Find the PBXFileReference section
    file_ref_section = re.search(r'\/\* Begin PBXFileReference section \*\/', content)
    if not file_ref_section:
        print("Error: Could not find PBXFileReference section")
        return False

    # Find the PBXBuildFile section
    build_file_section = re.search(r'\/\* Begin PBXBuildFile section \*\/', content)
    if not build_file_section:
        print("Error: Could not find PBXBuildFile section")
        return False

    # Find the PBXSourcesBuildPhase section to add to sources
    sources_section = re.search(r'(\/\* Begin PBXSourcesBuildPhase section \*\/.*?files = \()(.*?)(\);)', content, re.DOTALL)
    if not sources_section:
        print("Error: Could not find PBXSourcesBuildPhase section")
        return False

    # Add PBXFileReference entries
    file_ref_entries = []
    for filename, path, group in missing_files:
        uuid_ref = file_refs[filename]
        entry = f'\t\t{uuid_ref} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "{path}"; sourceTree = "<group>"; }};'
        file_ref_entries.append(entry)

    # Add PBXBuildFile entries
    build_file_entries = []
    for filename, path, group in missing_files:
        uuid_build = build_files[filename]
        uuid_ref = file_refs[filename]
        entry = f'\t\t{uuid_build} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {uuid_ref} /* {filename} */; }};'
        build_file_entries.append(entry)

    # Add to sources build phase
    source_entries = []
    for filename, path, group in missing_files:
        uuid_build = build_files[filename]
        entry = f'\t\t\t\t{uuid_build} /* {filename} in Sources */,'
        source_entries.append(entry)

    # Insert the entries
    # Find insertion point for PBXFileReference (after the section start)
    file_ref_insert_pos = file_ref_section.end()
    content = content[:file_ref_insert_pos] + '\n' + '\n'.join(file_ref_entries) + content[file_ref_insert_pos:]

    # Re-find build file section (positions changed)
    build_file_section = re.search(r'\/\* Begin PBXBuildFile section \*\/', content)
    build_file_insert_pos = build_file_section.end()
    content = content[:build_file_insert_pos] + '\n' + '\n'.join(build_file_entries) + content[build_file_insert_pos:]

    # Re-find sources section (positions changed again)
    sources_section = re.search(r'(\/\* Begin PBXSourcesBuildPhase section \*\/.*?files = \()(.*?)(\);)', content, re.DOTALL)
    sources_list = sources_section.group(2)
    sources_insert_pos = sources_section.start(2)
    sources_end_pos = sources_section.end(2)

    new_sources = sources_list.rstrip() + '\n' + '\n'.join(source_entries) + '\n\t\t\t'
    content = content[:sources_insert_pos] + new_sources + content[sources_end_pos:]

    # Write back
    with open(project_file, 'w') as f:
        f.write(content)

    print("✅ Successfully added missing files to Xcode project!")
    print("\nAdded files:")
    for filename, path, group in missing_files:
        print(f"  - {path}")

    return True

if __name__ == "__main__":
    print("Adding missing Swift files to Xcode project...")
    print("=" * 60)
    success = add_files_to_project()

    if success:
        print("\n" + "=" * 60)
        print("Next steps:")
        print("1. Open BlueWaveRadio.xcodeproj in Xcode")
        print("2. Clean the build folder (Cmd+Shift+K)")
        print("3. Build the project (Cmd+B)")
        print("\nThe 'Cannot find WeatherManager in scope' error should now be fixed!")
    else:
        print("\n❌ Failed to add files automatically.")
        print("Please add the files manually through Xcode (see add_missing_files.sh for instructions)")
