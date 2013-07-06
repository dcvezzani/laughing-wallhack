require './test/my_colors'

def run_test(file)
  system('clear')

  unless File.exist?(file)
    msg = "#{file} does not exist"
    #puts (colorize msg, MyColors::RED)
    puts msg
    return
  end

  puts "Running #{file}"
  #system "ruby -I . --color --tty #{file}"
  #system "ruby -I . #{file}"
  res = system "bundle exec ruby -I . #{file}"
  #res = `bundle exec ruby -I . #{file}`
  puts
  if(res)
    puts (colorize "tests passed!", MyColors::GREEN)
  else
    puts (colorize "!!! trouble in River City !!!", MyColors::RED)
  end
end

#watch("spec/.*/*_spec.rb") do |match|
watch("test/.*/*_test.rb") do |match|
  run_test match[0]
end

watch("app/(.*).rb") do |match|
  run_test  %{test/#{match[1]}_test.rb}
end

def run_all_tests
  system('clear')
  res = system "bundle exec rake test"
  #growl result.split("\n").last rescue nil
  puts
  if(res)
    puts (colorize "tests passed!", MyColors::GREEN)
  else
    puts (colorize "!!! trouble in River City !!!", MyColors::RED)
  end
end

def run_suite
  run_all_tests
  @interrupted = false
  #run_all_features
end

@interrupted = false
 
# Ctrl-C
Signal.trap 'INT' do
  if @interrupted then
    @wants_to_quit = true
    abort("\n")
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    Kernel.sleep 1.5
    # raise Interrupt, nil # let the run loop catch it
    run_suite
  end
end
