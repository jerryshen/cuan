require 'win32ole'
module ExcelRill
	def self.get_area_data(sheet, option)    
		rows = sheet.UsedRange.Rows.count
		cols = sheet.UsedRange.columns.count

		default = {:start_row => 1,:start_column=> 1, :end_row => -1, :end_column => -1}
		option = default.merge!(option)

    raise "数据区域范围错误：开始行号必须大于0" unless option[:start_row] > 0
    raise "数据区域范围错误：开始列号必须大于0" unless option[:start_column] > 0

		startRow = option[:start_row] 
		startCol = option[:start_column] 
		endRow = rows + option[:end_row] +1 
		endCol = cols + option[:end_column] + 1

    raise "数据区域范围错误：结束行号#{endROw}大于起始行号#{startRow}" unless endRow >= startRow
    raise "数据区域范围错误：结束列号#{endCol}大于起始列号#{startCol}" unless endCol >= startCol

		data = []
		for row in startRow..endRow
		  row_data = data[data.length] = []      
		  for col in startCol..endCol 
        row_data << sheet.Cells(row,col).value
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
          hashRow[key] = dataRow[col]
        else
          raise "第#{col}列的key不存在"
        end
		  end
		end
		return hashdata
	end

  #获取某个单元格的值
  def self.get_cell_value(sheet,row,col)
    return sheet.Cells(row,col).value
  end

  def self.parse_excel(file_path,blocks)
    raise "文件不存在" unless File.exist?(file_path)
    excel = WIN32OLE::new('excel.Application')
		excel.visible = false     # in case you want to see what happens 
		excel.Application.DisplayAlerts = false
		workbook = excel.Workbooks.Open(file_path)
    begin
      blocks.each{ |proc| proc.call(workbook)}
		rescue => error
      raise error
		ensure
		  excel.Workbooks.Close
		  excel.Quit
		end
  end


  def self.parse_sheet(workbook,index,blocks)
    sheet = workbook.Worksheets(index)
    sheet.Select
    blocks.each{|proc| proc.call(sheet)}
    sheet = nil
  end
end

def import_salary(file_path,option)
		default = {:sheet_index => 1,:keys=> [], :month_cell => {:row => 1,:col => 1}}
		option = default.merge(option)
    raise "工作表号必须大于0" unless option[:sheet_index] > 0

		hash_data = [] 
    proc_workbook = lambda do |workbook|
      row_data = []
      procs = []
      get_salary_detail = lambda  do |sheet|
        row_data = ExcelRill.get_area_data(sheet,option[:data_area])
      end
      procs << get_salary_detail
     
      if option[:month_cell]
        year_month = ''
        get_year_month = lambda do |sheet|
          pos = option[:month_cell]
          year_month = ExcelRill.get_cell_value(sheet,pos[:row],pos[:col])
        end
        procs << get_year_month
      end
      ExcelRill.parse_sheet(workbook,option[:sheet_index],procs)

      hash_data = ExcelRill.convert_to_hash(row_data,option[:keys])
      
      if option[:month_cell] && !year_month.empty?
        year_month = year_month[-7..-1].split('-')
        if(year_month.length == 2)
          year = year_month[0][-4..-1]
          month = year_month[1]
          hash_data.each do |row|
            row[:year] = year
            row[:month] = month
          end
        end
      end
      
    end
    ExcelRill.parse_excel(file_path,[proc_workbook])
    return hash_data
  end
  
def print_data(data)
  data.each_index do |i|
    puts 
    puts "----第#{i+1}条数据----"
    
    data[i].each_key do |key|
      puts "#{key}: #{data[i][key]}"
    end
  end
end

def import_lixu_renyuan_gongzi
  option = {:data_area=>{:start_row=>5,:start_column=>2}}
  option[:sheet_index]=2
  option[:keys]= %w(姓名	月基本离休费	工改保留补贴_93年	其他国家出台津补贴	地方出台津补贴	补发工资	扣水费	应发工资	应扣项	实发工资)
  data=import_salary("D:/My Documents/git/cuan/doc/xls/5月离休人员工资.xls",option)
  print_data(data)
end


def import_zaizi_xueyuan_gongzi
  option = {:data_area=>{:start_row=>2,:start_column=>3}}
  option[:month_cell]=nil
  option[:sheet_index]=1
  option[:keys]= %w(姓名	日期	岗位工资	薪级工资	艰苦边远地区津贴	工改保留补贴	其他国家出台津贴	地方出台津贴	扣发工资	补发工资	生活补贴	补贴补差	活工资补差	电视补贴	驻蓉补贴	其他1	应发工资	住房公积金	职工医疗保险费	职工个人教育费	个人所得税	扣水电费	扣失业保险费	其他扣款一	其他扣款二	其他扣款三	实发工资)
  data=import_salary("D:/My Documents/git/cuan/doc/xls/09年5月在职学院工资.xls",option)
  print_data(data)  
end

#!!!not over
def import_tuixiu_renyuan_gongzi
  option = {:data_area=>{:start_row=>7,:start_column=>2}}
  option[:sheet_index]=2
  option[:keys]= %w(姓名	月基本退休费	工改保留补贴_93年	其他国家出台津补贴	地方出台津补贴	扣水费	其他扣款二	其他扣款三	应发工资	应扣项	实发工资)
  data=import_salary("D:/My Documents/git/cuan/doc/xls/5月退休人员工资.xls",option)
  print_data(data)  
end


def import_tuixiu_renyuan_xueyuan_gongzi
  option = {:data_area=>{:start_row=>2,:start_column=>2}}
  option[:month_cell]=nil
  option[:sheet_index]=1
  option[:keys]= %w(姓名	日期	补贴补差	电视补贴	驻蓉补贴	其他一	其他二	其他三	扣水电费	其他扣款一	其他扣款二	其他扣款三	实发金额)
  data=import_salary("D:/My Documents/git/cuan/doc/xls/09年5月退休人员学院工资.xls",option)
  print_data(data)  
end

def import_caizheng_zaizi_gongzi_beifen
  option = {:data_area=>{:start_row=>4,:start_column=>2}}
  option[:sheet_index]=1
  option[:keys]= %w(姓名	岗位工资	技术等级（职务）工资	岗位津贴	其他国家出台津补贴	地方出台津补贴	补发工资	扣住房公积金	扣职工医疗保险费	扣水费	扣失业保险	其他扣款一	其他扣款二	其他扣款三	应发工资	应扣项	实发工资)
  data=import_salary("D:/My Documents/git/cuan/doc/xls/5月财政在职工资备份.xls",option)
  print_data(data)  
end

#~ import_lixu_renyuan_gongzi
#~ import_zaizi_xueyuan_gongzi
#~ import_tuixiu_renyuan_gongzi
#~ import_tuixiu_renyuan_xueyuan_gongzi
#~ import_caizheng_zaizi_gongzi_beifen