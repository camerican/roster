#
# person.rb - Persons and their methods
#
# The Person class contains attributes and export formatting for people
# within the context of the Cyrus Code Test
#
 
require_relative "ingest"
require "time"

class Person
    
  include Ingest      #import Ingest module
    
  attr_accessor :last_name, :first_name, :gender, :date_of_birth, :favorite_color, :middle_initial

  def initialize( line=nil, type=nil )
    unless line.nil? || line.empty?
      load_line( line, type )
    else
      []
    end
  end

  def load_line( line, type=nil )
    if type.nil?     #if we do not have the type, detect
      type = detect_type( line )
    end
       
    #case values are linked to Ingest.FORMAT_TYPE array keys
    case type
    #load pipe delimited data
      when 0
        line.split(FORMAT_TYPE[0]['del']).each_with_index do | val, key |
          case key
            when 0
                @last_name = val.strip
            when 1
                @first_name = val.strip
            when 2
                @middle_initial = val.strip     # can ignore middle_initial, but load anyway
            when 3
                @gender = format_gender(val.strip)
            when 4
                @favorite_color = val.strip
            when 5
                @date_of_birth = Date.parse(val.strip)  #rely upon Ruby Date.parse
            else
                raise "Malformed index in load_line for "+FORMAT_TYPE[0]['type']+"format"
          end
        end
      #load comma delimited data
      when 1
        line.split(FORMAT_TYPE[1]['del']).each_with_index do | val, key |
          case key
            when 0
              @last_name = val.strip
            when 1
              @first_name = val.strip
            when 2
              @gender = format_gender(val.strip)
            when 3
              @favorite_color = val.strip
            when 4
              @date_of_birth = Date.strptime(val.strip,"%m/%d/%Y")  #rely upon Ruby Date.parse
              #@date_of_birth = "1"
            else
              raise "Malformed index in load_line for "+FORMAT_TYPE[1]['type']+"format"
          end
        end
      #load space delimited data (don't use strip for space delimited, obvs)
      when 2
        line.split(FORMAT_TYPE[2]['del']).each_with_index do | val, key |
          case key
            when 0
              @last_name = val
            when 1
              @first_name = val
            when 2
              @middle_initial = val      # can ignore middle_initial but we load anyway
            when 3
              @gender = format_gender(val)
            when 4
              @date_of_birth = Date.parse(val)  #rely upon Ruby Date.parse
            when 5
              @favorite_color = val
            else
              raise "Malformed index in load_line for "+FORMAT_TYPE[2]['type']+"format"
          end
        end
      else
        raise "No format type detected for person import operation"
    end
    self  #return self
  end

  #standardize formatting for gender to 1 letter M/F
  #or Male/Female for outputting
  #this assumes M(ale)/F(emale) formatting
  def format_gender( input, mode=0 )
    if mode==0
      input.upcase[0]
    else
      if input.upcase[0] == 'M' 
        "Male"
      else
        "Female"
      end
    end 
  end

  def format_date( input )
    if input.instance_of?(Date)
      input.strftime("%-m/%-d/%Y")
    else
      ""
    end
  end

  def to_s
    @last_name + " " + @first_name + " " + format_gender(@gender,1) + " " + format_date(@date_of_birth) + " " + @favorite_color
  end

end