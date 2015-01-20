#
# roster.rb - Collection of People
#
# The Roster class contains methods for Ingestion, Sort, and Export
# of persons within the Cyrus Code Test
#
require_relative "person"
require_relative "ingest"

class Roster
 	include Ingest      #import Ingest module

	attr_accessor :roster

# Load roster from file
# Params:
# +files+:: line of content to process
	def initialize( *files )
		@roster = []	#roster is blank to start

		unless files.nil? || files.empty?
			#process each file
			files.each do | x | 
				ingest_dir(x, @roster, Person)
			end
		else 
			puts "no files"
			ingest_dir(Dir.pwd, @roster, Person)	#process current directory
		end
	end

	def to_s
		puts 'Output 1'
		puts @roster.sort_by { |x| [x.gender,x.last_name.downcase,x.first_name.downcase] }
		puts ""
		puts 'Output 2'
		puts @roster.sort_by { |x| [x.date_of_birth,x.last_name.downcase,x.first_name.downcase] }
		puts ""
		puts 'Output 3'
		puts @roster.sort { |x,y| [y.last_name.downcase,y.first_name.downcase] <=> [x.last_name.downcase,x.first_name.downcase] }
		""
	end
end
