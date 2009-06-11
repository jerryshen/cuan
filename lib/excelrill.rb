require 'win32ole'
module ExcelRill
	def self.parse_sheet(sheet, option)    
		sheet.Select
		rows = sheet.UsedRange.Rows.count
		cols = sheet.UsedRange.columns.count

		default = {:start_row => 1,:start_column=> 1, :end_row => -1, :end_column => -1}
		option = default.merge!(option)

		startRow = option[:start_row] 
		startCol = option[:start_column] 
		endRow = rows + option[:end_row] +1 
		endCol = cols + option[:end_column] + 1

		data = []
		for row in startRow..endRow
		  row_data = data[data.length] = []      
		  for col in startCol..endCol 
        row_data << sheet.Cells(row,col).value
		  end
		end
		return data
	end

	#keys["字段1","字段2","字段3"]
	def self.convert_to_hash(data,keys)
		hashdata = []
		data.each_index do |row|
		  hashRow = hashdata[row] = {}
		  dataRow = data[row]
		  dataRow.each_index do |col|
        hashRow[keys[col]] = dataRow[col]
		  end
		end
		return hashdata
	end

	def self.convert_xls_to_hash(file_path,option)
		default = {:sheet_index => 1,:keys=> []}
		option = default.merge(option)
    
		hash_data = []
		excel = WIN32OLE::new('excel.Application')
		excel.visible = false     # in case you want to see what happens 
		excel.Application.DisplayAlerts = false
		workbook = excel.Workbooks.Open(file_path)
    begin
		  worksheet = workbook.Worksheets(option[:sheet_index])
		  sheet_data = parse_sheet(worksheet,option[:data_area])
		  hash_data = convert_to_hash(sheet_data,option[:keys])
		rescue
		  #处理错误
		ensure
		  excel.Workbooks.Close
		  excel.Quit
		end
		return hash_data
	end
end
file_path = "E:\\9.xls"
data=ExcelRill::convert_xls_to_hash(file_path,{:data_area=>{:start_row=>2,:end_column=>-22},:keys=>"姓名	日期	岗位工资	薪级工资	艰苦边远地区津贴	工改保留补贴".split(" ")  })
puts data