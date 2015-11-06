# aplicação construída em OS X com Ruby 2.2.3
# se necessário, rodar 'gem install filewatcher' antes de rodar a aplicação

require 'filewatcher'

INPUT_PATH = './data/in/'
OUTPUT_PATH = './data/out/'

DATA_EXT = '.dat'
REPORT_EXT = '.done.dat'

FileWatcher.new([File.join(INPUT_PATH, '*' + DATA_EXT)]).watch do |filename, event|
  if (event == :new)
    basename = File.basename(filename, DATA_EXT)
    done_filename = "#{basename}#{REPORT_EXT}"

    unless File.exist?(File.join(OUTPUT_PATH, done_filename))
      Processor.new().process(filename, done_filename)
    end
  end
end
