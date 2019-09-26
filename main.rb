require 'optparse'
require 'bundler'
Bundler.require

ECMA_CSI = "\e[".freeze
def clear_line
  print(ECMA_CSI + '0m' + TTY::Cursor.clear_line)
end

CENTENCE_NUM = 10

reader = TTY::Reader.new
pastel = Pastel.new
success = 0
miss = 0
all_time = 0

yml_file = ARGV[0] || 'default'
questions = YAML.load_file("questions/#{yml_file}.yml")[:questions]

puts 'Start Typing...!!'

CENTENCE_NUM.times do
  puts ''
  puts ''
  question = questions.sample
  answer = ''
  buffer = ''
  first = true
  puts question[:kanji]
  print question[:kana]
  while question[:kana] != answer.to_kana
    buffer = reader.read_char
    if first
      start_at = Time.now
      first = false
    end
    # Backspace
    if buffer == "\u007F"
      answer = answer.to_kana[0..-2].to_roma
      miss += 1
    else
      answer << buffer
      success += 1
    end
    clear_line
    missed = false
    question[:kana].each_char.with_index do |char, i|
      if i < answer.to_kana.length
        if answer.to_kana[i] == char && !missed
          print pastel.on_blue(char)
        else
          print pastel.on_red(char)
          missed = true
        end
      else
        print char
      end
    end
  end
  all_time += Time.now - start_at
end

puts ''
puts ''
puts '**************************************'
puts "  Diff   : #{all_time.round(2)}s"
puts "  Touch  : #{success}"
puts "  Miss   : #{miss}"
puts "  Speed  : #{(success / all_time * 60).round}word/minute"
puts "  Correct: #{(success / (success + miss).to_f).round(2) * 100}%"
puts '**************************************'
