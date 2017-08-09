# encoding: UTF-8
# aplicação construída em OS X com Ruby 2.2.3
# se necessário, rodar 'gem install filewatcher' antes de rodar a aplicação

require 'filewatcher'
require File.expand_path(File.join(File.dirname(__FILE__), 'processor'))

INPUT_PATH = './data/in/'
OUTPUT_PATH = './data/out/'

DATA_EXT = '.dat'
REPORT_EXT = '.done.dat'

INPUT_FILEMASK = File.join(INPUT_PATH, '*' + DATA_EXT)

def check_and_go(input_file)
  basename = File.basename(input_file, DATA_EXT)
  output_file = File.join(OUTPUT_PATH, "#{basename}#{REPORT_EXT}")

  unless File.exist?(output_file)
    Processor.new(input_file, output_file).process
    puts "#{input_file} processado."
  end
end

# processar todos arquivos da pasta
Dir.glob(INPUT_FILEMASK) do |input_filename|
  check_and_go(input_filename)
end

# monitorar arquivos novos
FileWatcher.new([INPUT_FILEMASK]).watch do |input_filename, event|
  if (event == :new)
    check_and_go(input_filename)
  end
end
