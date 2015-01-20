## Ruby Roster Processor

Hey guys, thanks for taking the time to check out this code.  If not too much trouble, it would be *awesome* if you could leave feedback at http://github.com/camerican/roster

I'm new to Ruby, so there is likely quite a few aspects of my code here that could be improved upon.  This code was developed against Ruby **version 2.1.2p95**.

### Project Files

* dotest.rb - The file to run in the command line: ruby dotest.rb
* roster.rb - Roster of all People (Persons)
* person.rb - Defines a Person that exists within a Roster
* ingest.rb - Generic data import Modle functionality
* comma.txt (input)
* pipe.txt (input)
* space.txt (input)

To run the project, the **dotest.rb** file should be ran through the ruby interpreter.

> ruby dotest.rb

**Do Test** simply instantiates **Roster** with the proper file inputs and then writes the desired ouput to the console.  For each input file, roster calls **Ingest::ingest_dir()** which is a generic intake method within the **Ingest** module.  The idea of creating a module of Generic utility functions is that it promotes *code reuse* for future projects unrelated to the Roster or Person classes.

Roster's **to_s** method implements all the magic of outputting data in this project by sorting **Person**s into the 3 output formats desired. Similarly, Person's **to_s** is called upon to output a Person in the desired project format.  The entirity of functions used in this project are further documented below.

##  Ingest Module (ingest.rb)

The Ingest Module is a generic collection of constants and methods that are used for importing data from files.

# MAX_RECURSIONS
MAX_RECURSIONS is a constant that sets the upper limit on the number of directories to be traversed in search of input files

# FORMAT_TYPES 
FORMAT_TYPES is a constant reference to an array containing hashes describing our delimiters for file processing

# detect_type( line )
Detect the type of line we're dealing with by searching for the appropriate delimiter, as defiend by FORMAT_TYPES

# ingest_dir( path, ar_object, class_type, recursion ) 
Processes the supplied path to read in our input files. Processed files are read line-by-line and for each line a **new** instance of **class_type** is created from the line-data. In this case, the class is Person, obviously, but the method remains generic so that it could be reused in other circumstances for other projects.

## Person Class (person.rb)
Persons are classes holding all the people-related data for our program.  This includes last_name, first_name, middle_initial, gender, favorite_color, and date_of_birth.

# initialize( line=nil, type=nil )
Persons are created by passing a line of comma, pipe, or space delimited data to the initialization function. The lines are actually processed by load_line().

# load_line( line, type=nil )
Process a line of input for all three delimiter format types

# format_gender( input, mode=0 )
Either strip gender down to M/F values (default) or make sure the value is Male/Female if the mode is set to a non-zero value.

# format_date( input )
Format the date so that we can avoid Date.parse problems.

# def to_s
The output format for our Persons, as defined by the output requirements.

The to_s function is defined here as a means of outputting th  

## Roster Class (roster.rb)

# initialize( *files )
Process all the files passed to Roster.

# to_s 
By implementing this method we define how Roster should be output when converted to a string, allowing us to tackle all the output formatting here.  This method implements the following output formatting:

* Output 1: sort by gender (females before males) then by last name ascending
* Output 2: sort by date_of_birth, ascending
* Output 3: sort by last_name, descending

In all cases of name formatting we have used first_name as a secondary or tertiary tie-break.

### Caveats

## Error Catching

This code has not been built with robust error handling, so there are problems if the input files are not formatted as expected.

## Unit Testing

Throughout the project, each aspect of code was tested against the irb console. Unfortunately, not being very familiar with RSpec, unit testing using this programmatic tool wasn't so effective for this project.  RSpec elements have been stripped down to a simple test on the person class.

Unit testing tends to work best when done progressively throughout the life of the project but here, since it was unfamiliar territory, manual tests were run.