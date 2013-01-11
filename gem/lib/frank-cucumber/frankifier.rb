require 'pathname'
require 'xcodeproj'

class Frankifier
  include Thor::Shell

  def self.frankify! root_dir, options = {}
    me = new(root_dir, options)
    me.frankify!
    me
  end

  def initialize( root_dir, options = {} )
    @root = Pathname.new( root_dir )
    @target_build_configuration = options[:build_config]
  end

  def frankify!
    decide_on_project
    decide_on_target
    report_project_and_target

    check_target_build_configuration_is_valid!

    say ''
    add_linker_flag

    say ''
    add_library_search_path

    save_changes
  end

  private
  def decide_on_project
    projects = Pathname.glob( @root+'*.xcodeproj' )
    xcodeproj = case projects.size
    when 0
      raise "There are no .xcodeproj files in this directory. Please move to your root project directory and try again."
    when 1
      projects.first
    else
      choice = ask_menu(
        "I found more than one .xcodeproj. Which is the main app project that you wish to Frankify?",
        projects.map(&:basename)
      )
      projects[choice]
    end

    @xcodeproj_path = xcodeproj
    @project = Xcodeproj::Project.new(xcodeproj)
  end

  def decide_on_target
    targets = @project.targets
    @target = case targets.size
    when 0
      raise "Sorry, this project appears to contain no targets. Nothing I can do here."
    when 1
      targets.first
    else
      choice = ask_menu(
        "I found more than one target in this project. Which is the main app target that you wish to Frankify?",
        targets.map(&:name)
      )
      targets.to_a[choice]
    end
  end

  def report_project_and_target
    puts "Frankifying target [#{@target.name}] in project #{@xcodeproj_path.basename}"
  end

  def target_is_mac
    settings = @target.build_configurations.first.build_settings['SDKROOT'] \
      || @project.build_configurations.first.build_settings['SDKROOT']

    return settings.include? 'macosx'
  end

  def add_linker_flag
    if target_is_mac
      add_frank_entry_to_build_setting( 'OTHER_LDFLAGS', 'FRANK_MAC_LDFLAGS' )
    else
      add_frank_entry_to_build_setting( 'OTHER_LDFLAGS', 'FRANK_LDFLAGS' )
    end
  end

  def add_library_search_path
    add_frank_entry_to_build_setting( 'LIBRARY_SEARCH_PATHS', 'FRANK_LIBRARY_SEARCH_PATHS' )
  end

  def add_frank_entry_to_build_setting( build_setting, entry_to_add )
    setting_array = Array( build_settings_to_edit[build_setting] )

    if setting_array.find{ |flag| flag.start_with? "$(FRANK_" }
      say "It appears that your '#{@target_build_configuration}' configuration's #{build_setting} build setting already include some FRANK setup. Namely: #{setting_array.inspect}. I won't change anything here."
      return
    end

    say "Adding $(inherited) and $(#{entry_to_add}) to your '#{@target_build_configuration}' configuration's #{build_setting} build setting ..."
    setting_array.unshift "$(inherited)"
    setting_array << "$(#{entry_to_add})"
    setting_array.uniq! # mainly to avoid duplicate $(inherited) entries
    say "... #{build_setting} is now: #{setting_array.inspect}"

    build_settings_to_edit[build_setting] = setting_array
  end

  def check_target_build_configuration_is_valid!
    unless @target.build_configuration_list.build_settings(@target_build_configuration)
      say %Q|I'm trying to Frankify the '#{@target_build_configuration}' build configuration, but I don't see it that build configuration in your XCode target. Here's a list of the build configurations I see:|
      @target.build_configuration_list.build_configurations.each do |bc|
        say "  '#{bc.name}'"
      end
      say ''
      say %Q|Please specify one of those build configurations using the --build_configuration flag|
      exit
    end

  end

  def build_settings_to_edit
    @_build_settings_to_edit ||= @target.build_configuration_list.build_settings(@target_build_configuration)
  end

  def save_changes
    @project.save_as( @xcodeproj_path )
  end

  # TODO: send this as a pull request to thor
  def ask_menu message, options
    option_lines = options.each_with_index.map{ |o,i| "#{i+1}: #{o}" }
    full_message = ([message,'']+option_lines+[">"]).join("\n")

    allowed_range = (1..options.length)
    valid_choice = nil
    until valid_choice
      choice = ask(full_message).to_i
      valid_choice = choice if allowed_range.include?(choice)
      say("You must choose an option between #{allowed_range.first} and #{allowed_range.last}") unless valid_choice
    end
    valid_choice-1
  end

end
