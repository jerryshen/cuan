#require 'excelrill'
require 'excelrillinux' #winOLE less
require 'file_upload_util'
class DataImport
  def self.collet_excel_data(file, category, year, month)
    file_path = upload_to_temp_dir(file)
    data = nil
    begin
      case category
      when "1"
        data = import_cz_zz(file_path, year, month)
      when "2"
        data = import_zz_xy(file_path, year, month)
      when "3"
        data = import_lx_ry(file_path, year, month)
      when "4"
        data = import_tx_ry(file_path, year, month)
      when "5"
        data = import_tx_ry_xy(file_path, year, month)
      end
    rescue => error
      raise error
    ensure
      delete_temp_file(file_path)
    end
    return data
  end

  def self.delete_temp_file(path)
    if File.exist?(path)
      File.delete(path)
    end
  end

  def self.upload_to_temp_dir(xls_file)
    ext_name = FileUploadUtil.get_file_ex_name(xls_file)
    if(ext_name == ".xls")
      save_name = FileUploadUtil.make_timestamp_file_name(xls_file)
      save_dir = RAILS_ROOT + '/tmp/import_xls_files'
      #save_dir = "D:" + '/tmp/import_xls_files'
      FileUploadUtil.save_file(xls_file,save_dir,save_name)
    else
      raise "请上传Excel文件(扩展名为.xls)"
    end
    return save_dir + "/" + save_name
  end

  def self.import_salary(file_path,option)
    default = {:encoding => 'GB2312',:sheet_index => 1,:keys=> [], :month_cell => {:row => 1,:col => 1}}
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

=begin
      if option[:month_cell]
        year_month = ''
        get_year_month = lambda do |sheet|
          pos = option[:month_cell]
          year_month = ExcelRill.get_cell_value(sheet,pos[:row],pos[:col])
        end
        procs << get_year_month
      end
=end
      ExcelRill.parse_sheet(workbook,option[:sheet_index],procs)

      hash_data = ExcelRill.convert_to_hash(row_data,option[:keys])

=begin
      if option[:month_cell] && !year_month.empty?
        year_month = year_month[-7..-1]
        unless year_month.nil?
          year_month = year_month.split('-')
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
=end

    end
    ExcelRill.parse_excel(file_path,[proc_workbook],option[:encoding])
    return hash_data
  end

  def self.print_data(data)
    as = []
    data.each_index do |i|
      as << "----第#{i+1}条数据----"
      data[i].each_key do |key|
        as << "#{key}: #{data[i][key]}"
      end
    end
    return as.join("\n")
  end

  #离休人员工资导入 --> Temp1表
  def self.import_lx_ry(path, year, month)
    option = {:data_area=>{:start_row => 4,:start_column => 1, :end_column => -4}}
    option[:sheet_index] = 1
    option[:keys] =          %w(f1	    f2          	f3	              f4	                f5	            f6	      f7	    f8)
    #option[:keys] =         %w(姓名	身份证号	月基本离休费	工改保留补贴_93年	其他国家出台津补贴	地方出台津补贴	补发工资	扣水费)
#RetiredBasicSalaryRecord   user_id basic_fee     stay_be           foreign_be          region_be        null     null
    data = import_salary(path,option)
    data.delete_if{ |row| row["f1"].to_i > 0 } #f1 => 姓名
    data.each do |row|
      row["year"] = year
      row["month"] = month
    end
    Temp1.create(data)
  end


  #在职学院工资导入 --> temp2表
  def self.import_zz_xy(path, year, month)
    option = {:data_area=>{:start_row => 1,:start_column => 2, :end_column => -2}}
    option[:month_cell]=nil
    option[:sheet_index]=0
    option[:keys]= %w(f1	  f2	   f3	       f4	      f5	              f6	          f7	              f8	          f9	      f10	      f11	      f12	      f13	        f14	      f15	      f16	       f17	  f18	        f19	            f20	            f21	        f22	      f23	          f24         f25         f26)
    #option[:keys]= %w(姓名	$日期  岗位工资	 薪级工资	艰苦边远地区津贴	工改保留补贴	其他国家出台津贴	地方出台津贴	扣发工资	补发工资	生活补贴	补贴补差	活工资补差	电视补贴	驻蓉补贴	$应发工资  其他1	住房公积金	职工医疗保险费	职工个人教育费	个人所得税	扣水电费	扣失业保险费	其他扣款一	其他扣款二	其他扣款三) 
#BasicSalaryRecord user_id  null  station_sa position_sa       hard_be  stay_be       foreign_be        region_be     null      add_sa 
#CollegeBeRecord                                                                                                                          life_be   diff_be   livesa_be   tv_be    beaulty_be           other_be
#FeeCuttingRecord                                                                                                                                                                                               room_fee    med_fee         selfedu_fee      self_tax   elc_fee   job_fee       other_fee1  other_fee2  other_fee3
    data=import_salary(path,option)
    data.each do |row|
      row["year"] = year
      row["month"] = month
    end    
    Temp2.create(data)
  end
  

  #退休人员工资导入 --> temp3表
  def self.import_tx_ry(path, year, month)
    option = {:data_area=>{:start_row => 4,:start_column => 1, :end_column => -4}}
    option[:sheet_index] = 1
    option[:keys] =         %w(f1   f2           f3              f4                  f5                 f6              f7      f8        f9)
    #option[:keys] =        %w(姓名	身份证号	月基本退休费	工改保留补贴_93年	其他国家出台津补贴	地方出台津补贴  $扣水费	其他扣款二	其他扣款三)
#RetiredBasicSalaryRecord  user_id  basic_fee     stay_be           foreign_be          region_be       null 
#RetiredFeeCuttingRecord                                                                                        other_fee2  other_fee3 
    data=import_salary(path,option)
    data.delete_if{ |row| row["f1"].to_i > 0 } #f1 => 姓名
    data.each do |row|
      row["year"] = year
      row["month"] = month
    end    
    Temp3.create(data)
  end


  #退休人员学院工资导入 --> temp4表
  def self.import_tx_ry_xy(path, year, month)
    option = {:data_area=>{:start_row => 1,:start_column => 1, :end_column => -2}}
    option[:month_cell]=nil
    option[:sheet_index]=0
    option[:keys]=          %w(f1   f2    f3        f4        f5        f6      f7      f8      f9        f10         f11         f12)
    #option[:keys]=         %w(姓名	日期	补贴补差	电视补贴	驻蓉补贴	其他一	其他二	其他三	$扣水电费	其他扣款一	其他扣款二	其他扣款三)
#RetiredCollegeBeRecord    user_id  null  diff_be   tv_be   beaulty_be other_be1 other_be2 other_be3
#RetiredFeeCuttingRecord                                                                                  other_fee1 other_fee2  other_fee3 
    data=import_salary(path,option)
    data.each do |row|
      row["year"] = year
      row["month"] = month
    end    
    Temp4.create(data)
  end

  #财政在职工资导入 --> temp5表
  def self.import_cz_zz(path, year, month)
    option = {:data_area=>{:start_row=>4,:start_column => 1, :end_column => -4}}
    option[:sheet_index] = 1
    option[:keys]=   %w(f1      f2      f3          f4                      f5          f6                  f7              f8          f9              f10                 f11     f12         f13         f14         f15)
    #option[:keys] = %w(姓名	身份证	岗位工资	技术等级（职务）工资	岗位津贴	其他国家出台津补贴	地方出台津补贴	补发工资	扣住房公积金	扣职工医疗保险费	扣水费	扣失业保险	其他扣款一	其他扣款二	其他扣款三)
#BasicSalaryRecord  user_id station_sa position_sa        station_sa  foreign_be         region_be        add_sa	
#FeeCuttingRecord                                                                                                   room_fee      med_fee           elc_fee job_fee     other_fee1 other_fee2  other_fee3
    data = import_salary(path,option)
    data.delete_if{ |row| row["f1"].to_i > 0 } #f1 => 姓名
    data.each do |row|
      row["year"] = year
      row["month"] = month
    end    
    Temp5.create(data)
  end

end


