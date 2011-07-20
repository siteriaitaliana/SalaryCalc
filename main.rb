### usage instructions: 
## => From the CLI just digit: ruby main.rb

#!/usr/bin/env ruby
require "csv" 
require "date"

class ProcessCSV
  
  attr_reader :csv_filename
  
  def checkProcessed?
      csv_file = CSV.read(csv_filename)
      csv_file.shift  
      
      months_processed = []
      salarydate_processed = []
      bonusdate_processed = []
      
      csv_file.each do |row|
        months_processed << row[0]
        salarydate_processed << row[1]
        bonusdate_processed << row[2]
      end  
      
      processed_length = months_processed.length
      
      if ((months_processed[0] != @current_month) || (processed_length != @remaining_months.length) || (processed_length != salarydate_processed.length) || (processed_length != bonusdate_processed.length))
            return false
      elsif ((!months_processed.all?) || (!salarydate_processed.all?) || (!bonusdate_processed.all?)) 
            return false
      else
            return true
      end
  end   
  
  def processMonths
      CSV.open(csv_filename, "wb") do |csv|
        csv << ["Month", "Salary Payment Date", "Bonus Payment Date"]
        
        @remaining_months.each do |month|
          
          month_index = @months.index(month)+1
          
          last_of_month = Date.civil(@current_year.to_i, month_index, -1)
          last_of_month = last_of_month.strftime(fmt='%A')

          fift_of_month = Date.civil(@current_year.to_i, month_index, 15)
          fift_of_month = fift_of_month.strftime(fmt='%A')
          
          checkEndDay(month_index, last_of_month, @salary_day)
          checkFiftDay(month_index, fift_of_month, @bonus_day)
                    
          csv << [month, @salary_day, @bonus_day] 
        end   
      end
      puts "All the months were processed in the file '#{csv_filename}'." 
  end
  
  def checkEndDay(month_index, last_of_month, salary_day)
      if (last_of_month == 'Sunday')
         @salary_day = Date.civil(@current_year.to_i, month_index, -3) 
      elsif (last_of_month == 'Saturday')
         @salary_day = Date.civil(@current_year.to_i, month_index, -2)
      else
         @salary_day = Date.civil(@current_year.to_i, month_index, -1)       
      end  
  end
  
  def checkFiftDay(month_index, fift_of_month, bonus_day)    
     if ((fift_of_month == 'Sunday'))
         @bonus_day = Date.civil(@current_year.to_i, month_index, 18) 
     elsif (fift_of_month == 'Saturday')
         @bonus_day = Date.civil(@current_year.to_i, month_index, 19)
     else
         @bonus_day = Date.civil(@current_year.to_i, month_index, 15)       
     end  
  end 

  def initialize(csv_filename = nil)
      @csv_filename = csv_filename
      @months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
      time = Time.new
      @salary_day = time.strftime("%D")
      @bonus_day = time.strftime("%D")
      @current_month = time.strftime("%B")
      @current_year = time.strftime("%Y")
      @currentmonth_index = @months.index(@current_month)
      @remaining_months = @months.slice(@currentmonth_index, @months.length)
    
      if (@csv_filename == nil)
        puts "Specify your .csv filename (default payroll.csv):"
        @csv_filename = gets.chomp
      end
  
      if @csv_filename == ''
        @csv_filename = 'payroll.csv'
      end
      
      if File.extname(@csv_filename) != '.csv'
        raise "Invalid filename"
      end
          
      if !File.exist?(@csv_filename)
        puts "File '#{@csv_filename}' being created and processed..."
        processMonths
      elsif !checkProcessed?
        puts "File '#{@csv_filename}' being processed..." 
        processMonths
      else
        puts "File '#{@csv_filename}' already created and processed."   
      end    
  end
  
end
  

processor = ProcessCSV.new()

