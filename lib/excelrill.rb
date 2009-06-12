require 'win32ole'
module ExcelRill
	def self.get_area_data(sheet, option)    
		rows = sheet.UsedRange.Rows.count
		cols = sheet.UsedRange.columns.count

		default = {:start_row => 1,:start_column=> 1, :end_row => -1, :end_column => -1}
		option = default.merge!(option)

    raise "��������Χ���󣺿�ʼ�кű������0" unless option[:start_row] > 0
    raise "��������Χ���󣺿�ʼ�кű������0" unless option[:start_column] > 0

		startRow = option[:start_row] 
		startCol = option[:start_column] 
		endRow = rows + option[:end_row] +1 
		endCol = cols + option[:end_column] + 1

    raise "��������Χ���󣺽����к�#{endROw}������ʼ�к�#{startRow}" unless endRow >= startRow
    raise "��������Χ���󣺽����к�#{endCol}������ʼ�к�#{startCol}" unless endCol >= startCol

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
          raise "��#{col}�е�key������"
        end
		  end
		end
		return hashdata
	end

  #��ȡĳ����Ԫ���ֵ
  def self.get_cell_value(sheet,row,col)
    return sheet.Cells(row,col).value
  end

  def self.parse_excel(file_path,blocks)
    raise "�ļ�������" unless File.exist?(file_path)
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
    raise "������ű������0" unless option[:sheet_index] > 0

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
    puts "----��#{i+1}������----"
    
    data[i].each_key do |key|
      puts "#{key}: #{data[i][key]}"
    end
  end
end

def import_lixu_renyuan_gongzi
  option = {:data_area=>{:start_row=>5,:start_column=>2}}
  option[:sheet_index]=2
  option[:keys]= %w(����	�»������ݷ�	���ı�������_93��	�������ҳ�̨����	�ط���̨����	��������	��ˮ��	Ӧ������	Ӧ����	ʵ������)
  data=import_salary("D:/My Documents/git/cuan/doc/xls/5��������Ա����.xls",option)
  print_data(data)
end


def import_zaizi_xueyuan_gongzi
  option = {:data_area=>{:start_row=>2,:start_column=>3}}
  option[:month_cell]=nil
  option[:sheet_index]=1
  option[:keys]= %w(����	����	��λ����	н������	����Զ��������	���ı�������	�������ҳ�̨����	�ط���̨����	�۷�����	��������	�����	��������	��ʲ���	���Ӳ���	פ�ز���	����1	Ӧ������	ס��������	ְ��ҽ�Ʊ��շ�	ְ�����˽�����	��������˰	��ˮ���	��ʧҵ���շ�	�����ۿ�һ	�����ۿ��	�����ۿ���	ʵ������)
  data=import_salary("D:/My Documents/git/cuan/doc/xls/09��5����ְѧԺ����.xls",option)
  print_data(data)  
end

#!!!not over
def import_tuixiu_renyuan_gongzi
  option = {:data_area=>{:start_row=>7,:start_column=>2}}
  option[:sheet_index]=2
  option[:keys]= %w(����	�»������ݷ�	���ı�������_93��	�������ҳ�̨����	�ط���̨����	��ˮ��	�����ۿ��	�����ۿ���	Ӧ������	Ӧ����	ʵ������)
  data=import_salary("D:/My Documents/git/cuan/doc/xls/5��������Ա����.xls",option)
  print_data(data)  
end


def import_tuixiu_renyuan_xueyuan_gongzi
  option = {:data_area=>{:start_row=>2,:start_column=>2}}
  option[:month_cell]=nil
  option[:sheet_index]=1
  option[:keys]= %w(����	����	��������	���Ӳ���	פ�ز���	����һ	������	������	��ˮ���	�����ۿ�һ	�����ۿ��	�����ۿ���	ʵ�����)
  data=import_salary("D:/My Documents/git/cuan/doc/xls/09��5��������ԱѧԺ����.xls",option)
  print_data(data)  
end

def import_caizheng_zaizi_gongzi_beifen
  option = {:data_area=>{:start_row=>4,:start_column=>2}}
  option[:sheet_index]=1
  option[:keys]= %w(����	��λ����	�����ȼ���ְ�񣩹���	��λ����	�������ҳ�̨����	�ط���̨����	��������	��ס��������	��ְ��ҽ�Ʊ��շ�	��ˮ��	��ʧҵ����	�����ۿ�һ	�����ۿ��	�����ۿ���	Ӧ������	Ӧ����	ʵ������)
  data=import_salary("D:/My Documents/git/cuan/doc/xls/5�²�����ְ���ʱ���.xls",option)
  print_data(data)  
end

#~ import_lixu_renyuan_gongzi
#~ import_zaizi_xueyuan_gongzi
#~ import_tuixiu_renyuan_gongzi
#~ import_tuixiu_renyuan_xueyuan_gongzi
#~ import_caizheng_zaizi_gongzi_beifen