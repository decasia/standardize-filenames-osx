#!/usr/bin/env ruby

# invoke with DRY_RUN=1 to do a dry run

require 'shellwords'

##### Constants #####

USAGE_MESSAGE = "Usage: ./standardize-filenames.rb /path/to/target/dir"

##### It facilitates testing to wrap the logic in a class #####

class StandardizeFilenames
  def run(path)
    abort("Invalid path") unless Dir.exist? path
    Dir.chdir path

    if ENV['DRY_RUN']
      say "** DRY RUN ENABLED **"
    end

    # get all filenames with uppercase letters
    count = 0
    files = Dir.glob('*[A-Z_]*') do |filename|
      standardized = standardize_name(filename)
      if standardized != filename
        count += 1

        say "#{filename} => #{standardized}"

        unless ENV['DRY_RUN']
          File.rename(filename, standardized)
        end
      end
    end

    unless count == 0
      say "Fixed #{count} filenames with standardize-filenames.rb"
    end
  end

  def standardize_name(filename)
    filename = filename.gsub('_', ' ') # remove any underscores
    chars = filename.chars
    chars.each_with_index.map { |c, i|
      downcase = false
      if uppercase?(c)
        subsequent = chars[i+1]
        prev = (i != 0) ? chars[i-1] : nil

        unless upper_or_digit?(prev) || upper_or_digit?(subsequent)
          downcase = true
        end
      end
      downcase ? c.downcase : c
    }.join
  end

  # string helper methods
  def uppercase?(s)
    s =~ /[A-Z]/
  end

  def upper_or_digit?(s)
    s =~ /[A-Z0-9]/
  end

  # when run by launchd, use logger instead of STDOUT
  def say(something)
    if $stdout.isatty
      puts something
    else  # log to system console
      escaped = Shellwords.shellescape something
      `logger #{escaped}`
    end
  end
end

##### Imperative script code goes here #####

if __FILE__ == $PROGRAM_NAME
  path = ARGV[0]
  abort(USAGE_MESSAGE) unless path
  StandardizeFilenames.new.run path
end
