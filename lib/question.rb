class Question
  attr_reader :text, :answers, :score, :time, :right_answer

  def initialize(answers, text, score, time)
    @answers = answers.keys
    @right_answer = answers.key(true)
    @text = text
    @score = score
    @time = time
  end

  def to_s
    <<~QUESTION
      #{@text} (цена вопроса: #{@score} баллов, время: #{@time} секунд.)
      #{@answers.map.with_index(1) { |answer, index| "#{index}. #{answer}" }.join("\n")}
    QUESTION
  end
end
