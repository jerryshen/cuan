require 'excelrill'
require 'file_upload_util'
class DataImport
  def self.collet_excel_data(file,category)
    file_path = upload_to_temp_dir(file)
    data = nil
    begin
      case category
      when "1"
        data = import_caizheng_zaizi_gongzi_beifen(file_path)
      when "2"
        data = import_zaizi_xueyuan_gongzi(file_path)
      when "3"
        data = import_lixu_renyuan_gongzi(file_path)
      when "4"
        data = import_tuixiu_renyuan_gongzi(file_path)
      when "5"
        data = import_tuixiu_renyuan_xueyuan_gongzi(file_path)
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
      FileUploadUtil.save_file(xls_file,save_dir,save_name)
    else
      raise "请上传Excel文件(扩展名为.xls)"
    end
    return save_dir + "/" + save_name
  end

  def self.import_salary(file_path,option)
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

  def self.import_lixu_renyuan_gongzi(path)
    option = {:data_area=>{:start_row=>5,:start_column=>2}}
    option[:sheet_index]=2
    option[:keys]= %w(姓名	月基本离休费	工改保留补贴_93年	其他国家出台津补贴	地方出台津补贴	补发工资	扣水费	应发工资	应扣项	实发工资)
    data=import_salary(path,option)
  end


  def self.import_zaizi_xueyuan_gongzi(path)
    option = {:data_area=>{:start_row=>2,:start_column=>3}}
    option[:month_cell]=nil
    option[:sheet_index]=1
    option[:keys]= %w(姓名	日期	岗位工资	薪级工资	艰苦边远地区津贴	工改保留补贴	其他国家出台津贴	地方出台津贴	扣发工资	补发工资	生活补贴	补贴补差	活工资补差	电视补贴	驻蓉补贴	其他1	应发工资	住房公积金	职工医疗保险费	职工个人教育费	个人所得税	扣水电费	扣失业保险费	其他扣款一	其他扣款二	其他扣款三	实发工资)
    data=import_salary(path,option)
  end

  #!!!not over
  def self.import_tuixiu_renyuan_gongzi(path)
    option = {:data_area=>{:start_row=>7,:start_column=>2}}
    option[:sheet_index]=2
    option[:keys]= %w(姓名	月基本退休费	工改保留补贴_93年	其他国家出台津补贴	地方出台津补贴	扣水费	其他扣款二	其他扣款三	应发工资	应扣项	实发工资)
    data=import_salary(path,option)
  end


  def self.import_tuixiu_renyuan_xueyuan_gongzi(path)
    option = {:data_area=>{:start_row=>2,:start_column=>2}}
    option[:month_cell]=nil
    option[:sheet_index]=1
    option[:keys]= %w(姓名	日期	补贴补差	电视补贴	驻蓉补贴	其他一	其他二	其他三	扣水电费	其他扣款一	其他扣款二	其他扣款三	实发金额)
    data=import_salary(path,option)
  end

  def self.import_caizheng_zaizi_gongzi_beifen(path)
    option = {:data_area=>{:start_row=>4,:start_column=>2}}
    option[:sheet_index]=1
    option[:keys]= %w(姓名	岗位工资	技术等级（职务）工资	岗位津贴	其他国家出台津补贴	地方出台津补贴	补发工资	扣住房公积金	扣职工医疗保险费	扣水费	扣失业保险	其他扣款一	其他扣款二	其他扣款三	应发工资	应扣项	实发工资)
    data=import_salary(path,option)
  end

end
