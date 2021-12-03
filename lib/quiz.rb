class Quiz
  def self.from_xml(path)
    xml = File.new(path, encoding: "utf-8")

    # Читаем данные xml-файла
    doc = REXML::Document.new(xml)

    # Закрываем файл.
    xml.close

    # создаем два массива из questions и answers
    questions = []
    # читаем вопросы в фале
    doc.elements.each('questions/question') do |question|
      answers = []

      # из прочитанного вопроса вынимаем ответы
      question.elements.each('answers/answer') do |answer|
        answers << [answer.text, answer.has_attributes?]
      end

      # помещаем в массив questions вопрос с атрибутами и перемешанные ответы
      questions << Question.new(answers.shuffle.to_h,
                                question.elements['text'].text,
                                question.attributes['score'].to_i,
                                question.attributes['time'].to_i)
    end

    Quiz.new(questions)
  end

  def initialize(questions)
    @questions = questions.shuffle
    @right_answers = 0
    @total_score = 0
    @current_index = 0
    @start_time = Time.now
  end

  # текущий вопросы
  def current_question
    @questions[@current_index]
  end

  def finished?
    @questions.size == @current_index
  end

  # определяем правильность ответа
  def answer_correct?(answer)
    current_question.answers[answer - 1] == right_answer
  end

  # правильный ответ в текущем вопросе
  def right_answer
    current_question.right_answer
  end

  # выводим следующий вопрос и суммируем максимальный балл
  def next_question
    @current_index += 1
  end

  # считаем максимальное количество баллов в викторине из массива вопросов
  def max_score
    @questions.map.sum { |key| key.score }
  end

  # метод посчетда баллов (кол-во правильных ответов и общий набранный балл)
  def calculate_score
    @right_answers += 1
    @total_score += current_question.score
  end

  # таймер на овтет
  def timeout?
    Time.now - @start_time > current_question.time
  end

  # сообщаем о завершении игры + выводим набранный результат
  def game_over
    <<~END
      --- GAME OVER! ---
         Время вышло!
      Вы успели правильно ответить на #{@right_answers} вопросов из #{@questions.size}, и набрали #{@total_score} баллов из #{max_score} возможных.
    END
  end

  # выводим результат игры ghb
  def result
    <<~GAME_RESULT
      Вы правильно ответили на #{@right_answers} вопросов из #{@questions.size}, и набрали #{@total_score} баллов из #{max_score} возможных.
    GAME_RESULT
  end
end
