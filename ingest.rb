#
# ingest.rb - Ingest lines
#
# The Ingest module extracts generic input/output functionality
# used for detecting delimiters for import
#

module Ingest

#maximum number of recursions allowed
MAX_RECURSIONS = 1
#delimiter threshold defines number of delimiters necessary to satisfy search
DELIMITER_THRESHOLD = 3
#file formats we accept for parsing
ACCEPTED_FILE_FORMATS = [".txt"]

#define constants for importing of person; #id defined by position
FORMAT_TYPE = [ { "del" => '|', "type" => "Pipe" },
                { "del" => ',', "type" => "Comma" },
                { "del" => ' ', "type" => "Space" }]

# Detect the delimiter format that current line is encoded with. Please note we must
# look for the space delimiter *last* since other delimiters contain whitespace padding
# Params:
# +line+:: line of content to process
# +outhandler+:: the format id of the line as defined by FORMAT_TYPE (may be nil)
    def detect_type( line )
        #loop through each format type, trying to split the line data with its delimiter
        #continue until DELIMITER_THRESHOLD is met
        FORMAT_TYPE.index { |x| line.split(x['del']).length >= DELIMITER_THRESHOLD }
    end

# Recursively load directories
# Params:
# +path+ The filepath to process
# +ar_object+ The array of processed objects to append to
# +class_type+ The type of object to create
# +recursion+ The number of iterations left before exhausting ourselves
# +outhandler+ 
    def ingest_dir( path, ar_object, class_type, recursion=MAX_RECURSIONS )
        if File.directory?(path)
            if(recursion>0) #only continue recursion if we haven't searched long enough yet
                Dir.foreach(path) do |item|
                    next if item == '.' or item == '..'
                    ingest_dir(item, ar_object, class_type, recursion-1)    #recursively load directory
                end
            end
        elsif File.file?(path) # && ACCEPTED_FILE_FORMATS.include? File.extname(path)
            #if filepath is of an acceptable extension, parse into array of lines
            f = File.open(path) or die "Unable to open file #{path}..."
            f.each_line { |line|
                ar_object.push class_type.new(line)
            }
        end      
    end
end
    
