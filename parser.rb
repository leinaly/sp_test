require_relative 'dependencies'

class Parser
  attr_reader :log_file, :msg

  def initialize(log_file_path)
    begin
      @log_file = log_file_path
      binding.pry
      whole_script
      print_msg
    ensure
      @log_file.close
    end
  end

  private

  def whole_script
    file_path, ip = ""
    calculate_visits = {}
    calculate_visits_uniq = {}
    File.foreach(log_file) do |line|
      file_path, ip = line.split(' ')
      new_page = calculate_visits.fetch(file_path, nil)
      new_page.nil? ? calculate_visits[file_path] = 1 : calculate_visits[file_path] += 1
      p line

      new_ip = calculate_visits_uniq.fetch(ip, nil)
      if new_ip.nil?
        calculate_visits_uniq[ip] = {file_path => 1}
      else
        calculate_visits_uniq[ip][file_path].nil? ? calculate_visits_uniq[ip][file_path] = 0 : calculate_visits_uniq[ip][file_path] += 1
      end
    end
    most_visited_pages = calculate_visits.sort_by(&:last).reverse
    binding.pry
  end

  def print_msg
    @msg = "Parsing finished"
  end
end

# initialize object

if $0 == __FILE__
  raise Errors::InvalidArgumentsError.new("Usage: #{$0} <filename>") unless ARGV.length == 1

  #raise ArgumentError, "Usage: #{$0} <filename>" unless ARGV.length == 1
  Parser.new(ARGV[0])
end
