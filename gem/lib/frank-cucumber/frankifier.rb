require 'pathname'
require 'xcodeproj'

class Frankifier
  include Thor::Shell

  def self.frankify! root_dir
    me = new(root_dir)
    me.frankify!
    me
  end

  def initialize( root_dir )
    @root = Pathname.new( root_dir )
  end

  def frankify!
    decide_on_project
    decide_on_target
    report_project_and_target
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

  def add_linker_flag
    add_frank_entry_to_build_setting( 'OTHER_LDFLAGS', 'FRANK_LDFLAGS' )
  end

  def add_library_search_path
    add_frank_entry_to_build_setting( 'LIBRARY_SEARCH_PATHS', 'FRANK_LIBRARY_SEARCH_PATHS' )
  end

  def add_frank_entry_to_build_setting( build_setting, entry_to_add )
    setting_array = Array( debug_build_settings[build_setting] )

    if setting_array.find{ |flag| flag.start_with? "$(FRANK_" }
      say "It appears that your Debug configuration's #{build_setting} build setting already include some FRANK setup. Namely: #{setting_array.inspect}. I won't change anything here."
      return
    end

    say "Adding $(inherited) and $(#{entry_to_add}) to your Debug configuration's #{build_setting} build setting ..."
    setting_array.unshift "$(inherited)"
    setting_array << "$(#{entry_to_add})"
    setting_array.uniq! # mainly to avoid duplicate $(inherited) entries
    say "... #{build_setting} is now: #{setting_array.inspect}"

    debug_build_settings[build_setting] = setting_array
  end

  def debug_build_settings
    @_debug_build_settings ||= @target.build_configuration_list.build_settings('Debug')
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
