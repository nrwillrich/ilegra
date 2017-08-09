# encoding: UTF-8

class Processor
  def initialize(input_file, output_file)
    @amount_salesman = 0
    @amount_customers = 0
    @input_file = input_file
    @output_file = output_file
    @most_expensive_sale_id = ""
    @amount_sale = 0.0
    @salesmans = {}
  end

  def process
    File.open(@input_file, "r:UTF-8", &:read).each_line do |line|
      case line[2] # beginning of line: 001, 002 or 003
        when '1'
          @amount_salesman += 1
        when '2'
          @amount_customers += 1
        when '3'
          sales_data(line.strip)
      end
    end
    report
  end

  def sales_data(line)
    line_code, sale_id, products, salesman_name = line.split('ç')
    amount = 0.0

    products = products[1..-2]
    products.split(',').each do |sales|
      id, quant, value = sales.split('-')
      amount += (quant.to_f * value.to_f)
    end

    if @salesmans[salesman_name]
      @salesmans[salesman_name] += amount
    else
      @salesmans[salesman_name] = amount
    end

    if (amount > @amount_sale)
      @most_expensive_sale_id = sale_id
      @amount_sale = amount
    end
  end

  def report
    File.open(@output_file, 'w:UTF-8') do |output|
      output.puts "Amount of clients in the input file: " + @amount_customers.to_s
      output.puts "Amount of salesman in the input file: " + @amount_salesman.to_s
      output.puts "ID of the most expensive sale: " + @most_expensive_sale_id
      worst_salesman = @salesmans.min_by{|k, v| v}
      output.puts "Worst salesman is " + worst_salesman[0] + ": " + worst_salesman[1].to_s
    end
  end
end
