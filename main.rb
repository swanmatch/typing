require 'bundler'
Bundler.require
ECMA_CSI = "\e[".freeze
def clear_line
  output.print(ECMA_CSI + '0m' + TTY::Cursor.clear_line)
end

CENTENCE_NUM = 3

reader = TTY::Reader.new
success = 0
miss = 0
all_time = 0

questions = [
  ["キーボードをつくらないと", "きーぼーどをつくらないと"],
  ["キーボードなんもわからん", "きーぼーどなんもわからん"],
  ["にるぽケ1000本出品する", "にるぽけ1000ほんしゅっぴんする"],
  ["悪目立ち中二病あいどる", "わるめだちちゅうにびょうあいどる"],
  ["軍曹には気をつけろ", "ぐんそうにはきをつけろ"],
  ["黄色いドットアイコンは強さの証", "きいろいどっとあいこんはつよさのあかし"],
  ["kawazuがこちらを見つめている", "かわずがこちらをみつめている"],
  ["電脳世界を翔ける銀翼の翼", "でんのうせかいをかけるぎんよくのつばさ"],
  ["情報化社会を切り裂く剣", "じょうほうかしゃかいをきりさくつるぎ"],
  ["キーボードなんもわからん", "きーぼーどなんもわからん"],
  ["エンドゲームは移りゆくもの", "えんどげーむはうつりゆくもの"],
]

puts "Start Typing...!!"

CENTENCE_NUM.times do
  puts ""
  puts ""
  question = questions.sample
  answer = ''
  buffer = ''
  first = true
  puts question[0]
  puts question[1]
  while question[1] != answer.to_kana do
    buffer = reader.read_char
    if first
      start_at = Time.now
      first = false
    end
    # backspace
    if buffer == "\u007F"
      answer = answer.to_kana[0..-2].to_roma
      miss += 1
    else
      answer << buffer
      success += 1
    end
    print(ECMA_CSI + '0m' + TTY::Cursor.clear_line)
    print answer.to_kana
  end
  end_at = Time.now
  all_time += end_at - start_at
end

puts ""
puts ""
puts " Diff  : #{all_time}"
puts " Count : #{success}"
puts " Miss  : #{miss}"
puts " Speed : #{success / all_time * 60}word/minute"
puts "correct: #{success / (success + miss).to_f * 100}%"
