# Подключим встроенный в руби класс Date для работы с датами
require 'date'

class Task < Post
  def initialize
    super # вызываем конструктор родителя

    # потом инициализируем специфичное для Задачи поле - дедлайн
    @due_date = Time.now
  end

  def initialize
    # Вызовем одноимённый метод (initialize) родителя (Post) методом super
    super

    # А потом добавим то, что будет отличаться у ребёнка — поле @due_date
    @due_date = ''
  end

  def read_from_console
    # Мы полностью переопределяем метод read_from_console родителя Post

    # Спросим у пользователя, что за задачу ему нужно сделать
    # Одной строчки будет достаточно
    puts "Что вам необходимо сделать?"
    @text = STDIN.gets.chomp

    # А теперь спросим у пользователя, до какого числа ему нужно это сделать
    # И подскажем формат, в котором нужно вводить дату
    puts "До какого числа вам нужно это сделать?"
    puts "Укажите дату в формате ДД.ММ.ГГГГ, например 12.05.2003"
    input = STDIN.gets.chomp

    # Для того, чтобы записть дату в удобном формате, воспользуемся методом parse класса Time
    @due_date = Date.parse(input)
  end

  def save
    file = File.new(file_path, "w:UTF-8")
    time_string = @created_at.strftime("%d.%m.%Y, %H:%M")
    file.puts(time_string + "\n\r")

    # Так как поле @due_date указывает на объект класса Date, мы можем вызвать у него метод strftime
    # Подробнее о классе Date читайте по ссылкам в материалах
    file.puts("Сделать до #{@due_date.strftime("%d.%m.%Y")}")
    file.puts(@text)

    file.close

    # Напишем пользователю, что задача добавлена
    puts "Ваша задача сохранена"
  end
end
