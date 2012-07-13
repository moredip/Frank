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

    @project_name = xcodeproj.basename
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
    puts "Frankifying target [#{@target.name}] in project #{@project_name}"
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
