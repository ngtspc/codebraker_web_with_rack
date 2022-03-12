class Codebraker
  attr_reader :generated_number
  attr_accessor :entered_number

  def initialize(entered_number = 0, attempts_count = 10)
    @entered_number = entered_number
    @attempts_count = attempts_count
    @generated_number = rand(1_000..10_000)
  end

  def self.wrong_input_defence(entered_number)
    until entered_number.to_s.length == 4
      entered_number = gets.chomp.to_i
    end
    entered_number
  end

  def compare(entered_number)
    @generated_number
    converted_entered_number = entered_number.to_s.split('')
    p converted_generated_number = @generated_number.to_s.split('')
    hidden_number = converted_generated_number.each_with_index.inject([]) do |hidden_number, (element, id)|
      compare_numbers(id, element, hidden_number, converted_entered_number)
    end
    p hidden_number.join('')
  end

  def compare_numbers(id, element, hidden_number, converted_entered_number)
    if converted_entered_number[id] == element
      hidden_number.push('+')
    elsif converted_entered_number.include?(element)
      hidden_number.push('-')
    else
      hidden_number.push('*')
    end
  end

  def check(entered_number)
    entered_number = wrong_input_defence(entered_number)
    compare(entered_number)
  end
end
