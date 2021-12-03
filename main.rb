if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

#-------------------

require_relative 'lib/question'
require_relative 'lib/quiz'
require 'rexml/document'

# указываем путь к xml-файлу
xml_path = File.dirname(__FILE__) + '/questions.xml'

quiz = Quiz.from_xml(xml_path)

puts 'Привет!'
puts 'Ответь на вопросы мини-викторины.'
puts 'На каждый вопрос дается некоторе время.'
puts

until quiz.finished? || quiz.timeout?

  # Выводим название вопроса
  puts quiz.current_question

  # получаем ответ игрока
  user_answer = STDIN.gets.to_i

  # проверка правильности ответа
  if quiz.answer_correct?(user_answer)
    puts 'Верно!'
    puts

    # счетчик баллов
    quiz.calculate_score
  else
    puts "Неправильно! Правильный ответ — #{quiz.right_answer}."
    puts
  end

  # выводим следующий вопрос
  quiz.next_question
end

# выводим инф. об окончании игры с итоговым резульатом
if quiz.timeout?
  puts quiz.game_over
else
  puts quiz.result
end
