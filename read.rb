# Подключаем класс Post и его детей
require_relative 'post.rb'
require_relative 'memo.rb'
require_relative 'link.rb'
require_relative 'task.rb'

# будем обрабатывать параметры командной строки по-взрослому с помощью спец. библиотеки руби
require 'optparse'

# Все наши опции будут записаны сюда
options = {}
# заведем нужные нам опции
OptionParser.new do |opt|
  opt.banner = 'Usage: read.rb [options]'

  opt.on('-h', 'Prints this help') do
    puts opt
    exit
  end

  opt.on('--type POST_TYPE', 'какой тип постов показывать (по умолчанию любой)') { |o| options[:type] = o } #
  opt.on('--id POST_ID', 'если задан id — показываем подробно только этот пост') { |o| options[:id] = o } #
  opt.on('--limit NUMBER', 'сколько последних постов показать (по умолчанию все)') { |o| options[:limit] = o } #

end.parse!

# Если пользователь вызвал метод чтения из БД с параметром идентификатора, вызываем метод find_by_id класса Post
result = if !options[:id].nil?
           Post.find_by_id(options[:id])
           #  иначе вызываем метод find_all с параметрами, указанными пользователем, и выводим таблицу всех записей
         else
           Post.find_all(options[:limit], options[:type])
         end

# Если был введен идентификатор, то выводим на экран запись с данным id
if result.is_a? Post
  puts "Запись #{result.class.name}, id = #{options[:id]}"

  result.to_strings.each { |line| puts line }
end

# Если идентификатора не было, то выводим таблицу всех записей, с указанными параметрами
if (!result.is_a? Post) && !result.nil?
  print '| id                 '
  print '| @type              '
  print '| @created_at        '
  print '| @text              '
  print '| @url               '
  print '| @due_date          '
  print '|'

  result.each do |row|
    puts

    row.each do |element|
      element_text = "| #{element.to_s.delete("\n")[0..17]}"
      element_text << ' ' * (21 - element_text.size)
      print element_text
    end

    print '|'
  end
end

puts