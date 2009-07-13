require 'rubygems'
require 'spreadsheet'
require 'iconv'
module ExcelRill
	def self.get_area_data(sheet, option)    
		rows = sheet.row_count
		cols = sheet.column_count

		default = {:start_row => 0,:start_column=> 0, :end_row => -1, :end_column => -1}
		option = default.merge!(option)

		    raise "数据区域范围错误：开始行号必须大于等于0" unless option[:start_row] >= 0
		    raise "数据区域范围错误：开始列号必须大于等于0" unless option[:start_column] >= 0

		startRow = option[:start_row] 
		startCol = option[:start_column] 
		endRow = rows + option[:end_row] 
		endCol = cols + option[:end_column]

		    raise "数据区域范围错误：结束行号#{endROw}大于起始行号#{startRow}" unless endRow >= startRow
		    raise "数据区域范围错误：结束列号#{endCol}大于起始列号#{startCol}" unless endCol >= startCol

		data = []
		for row in startRow..endRow
		  row_data = data[data.length] = []      
		  #puts "row: #{row}"
		  for col in startCol..endCol
			#puts "col: #{col} => #{self.get_cell_value(sheet, row, col)}"
			row_data << self.get_cell_value(sheet, row, col)
		  end
		end
		return data
	end

	def self.convert_to_hash(data,keys)
		hashdata = []
		data.each_index do |row|
		  hashRow = hashdata[row] = {}
		  dataRow = data[row]
		  dataRow.each_index do |col|
        if key = keys[col]
	  begin
		hashRow[key] = Iconv.iconv("UTF-8//IGNORE","GBK//IGNORE",dataRow[col].to_s)[0]
	  rescue
		hashRow[key] = dataRow[col].to_s
	  end
          #hashRow[key] =dataRow[col].to_s
        else
          key = "第#{col}列"
          hashRow[key] = dataRow[col].to_s
          #raise "第#{col}列的key不存在"
        end
		  end
		end
		return hashdata
	end

  #获取某个单元格的值
  def self.get_cell_value(sheet,row,col)
    return sheet.row(row)[col]
  end

  def self.parse_excel(file_path,blocks,*encoding)
    raise "文件不存在" unless File.exist?(file_path)
		workbook = Spreadsheet.open(file_path)
    unless(encoding.length > 0)
      Spreadsheet.client_encoding = encoding[0]
    end
    begin
      blocks.each{ |proc| proc.call(workbook)}
		rescue => error
      raise error
		ensure
      #some operate
		end
  end


  def self.parse_sheet(workbook,index,blocks)
    sheet = workbook.worksheet(index)
    blocks.each{|proc| proc.call(sheet)}
    sheet = nil
  end
end

=begin

def import_salary(file_path,option)
    default = {:encoding => 'GBK',:sheet_index => 1,:keys=> [], :month_cell => {:row => 1,:col => 1}}
    option = default.merge(option)
    raise "工作表号必须大于等于0" unless option[:sheet_index] >= 0

    hash_data = []
    proc_workbook = lambda do |workbook|
      row_data = []
      procs = []
      get_salary_detail = lambda  do |sheet|
        row_data = ExcelRill.get_area_data(sheet,option[:data_area])
      end
      procs << get_salary_detail

      ExcelRill.parse_sheet(workbook,option[:sheet_index],procs)

      hash_data = ExcelRill.convert_to_hash(row_data,option[:keys])
    end
    ExcelRill.parse_excel(file_path,[proc_workbook],option[:encoding])
    return hash_data
  end

  def print_data(data)
    as = []
    data.each_index do |i|
      as << "----第#{i+1}条数据----"
      data[i].each_key do |key|
        as << "#{key}: #{data[i][key]}"
      end
    end
    return as.join("\n")
  end

def import_lx_ry(path, year, month)
    option = {:data_area=>{:start_row => 4,:start_column => 1, :end_column => -4}}
    option[:sheet_index] = 1
    option[:keys] =          %w(f1	    f2          	f3	              f4	                f5	            f6	      f7)
    data = import_salary(path,option)
    data.delete_if{ |row| row["f1"].to_i > 0 }
    data.each do |row|
      row["year"] = year
      row["month"] = month
    end
    puts print_data(data)
  end

import_lx_ry("5y.xls", 2009, 5)
=end