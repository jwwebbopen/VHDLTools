#!/usr/bin/perl

#------------------------------------------------------------------------------ 
# VHDL Component Instantiation
#	by Jeremy Webb
#	
#	Rev 1.1, November 3, 2004
#
#	This utility is intended to make instantiation in VHDL easier using
#	a good editor, such as VI.
#	
#	As long as you set the top line to correctly point to your perl binary,
#	and place this script in a directory in your path, you can invoke it from VI.
#	Simply use the !! command and call this script with the filename you wish
#	to instantiate.  
#		!! vhdl_inst adder.vhd
#	The script will retrieve the module definition from the file you specify and
#	provide the instantiation for you in the current file at the cursor position.
#
#	For instance, if adder.vhd contains the following definition:
#	
#		entity adder is
#		        port (
#		              a : in std_logic_vector (2 downto 0);
#		              b : in std_logic_vector (2 downto 0);
#		              sum : out std_logic_vector (2 downto 0);
#		              carry   : out   std_logic_vector (2 downto 0)
#		              );
#		end adder;
#       
#       Note that the closing ); can be placed either on the next line after the 
#       last port or on the same line as the last port in the entity declaration.
#       However, I would suggest that you don't append the ); on the end of last
#       line, otherwise you will end up with the two of them. One at the end of 
#       the last line, and another on the beginning of the next line.
#
#	Then this is what the script will insert in your editor for you:
#	
#		component adder
#		        port (
#		              a : in std_logic_vector (2 downto 0);
#		              b : in std_logic_vector (2 downto 0);
#		              sum : out std_logic_vector (2 downto 0);
#		              carry   : out   std_logic_vector (2 downto 0));
#		end component;
#
#	The keyword "entity" must be left justified in the vhdl file you are 
#	instantiating to work.
#
#	Revision History:
#		1.0	10/24/2004	Initial release
#		1.1     11/2/2004       Tom Anderson helped me re-write it for VHDL.
#
#	Please report bugs, errors, etc.
#------------------------------------------------------------------------------

#	Retrieve command line argument
#
use strict;
my $file = $ARGV[0];

#	Read in the target file into an array of lines
open(inF, $file) or dienice ("file open failed");
my @data = <inF>;
close(inF);

#	Strip newlines
foreach my $i (@data) {
	chomp($i);
	$i =~ s/--.*//;		#strip any trailing -- comments
}

#	initialize counters
my $lines = scalar(@data);		#number of lines in file
my $line = 0;
my $entfound = -1;

#	find 'entity' left justified in file
for ($line = 0; $line < $lines; $line++) {
	if ($data[$line] =~ m/^entity/) {
		$entfound = $line;
		$line = $lines;	#break out of loop
	}
}

# find 'end $file', so that when we're searching for ports we don't include local signals.
my $entendfound = 0;
$file =~ s/\.vhd$//;
for ($line = 0; $line < $lines; $line++) {
	if ($data[$line] =~ m/^end $file/) {
		$entendfound = $line;
		$line = $lines;	#break out of loop
	}
}


#	if we didn't find 'entity' then quit
if ($entfound == -1) {
	print("Unable to instantiate-no occurance of 'entity' left justified in file.\n");
	exit;
}

#find opening paren for port list
$entendfound = $entendfound + 1;
my $pfound = -1;

for ($line = $entfound; $line < $entendfound; $line++) { #start looking from where we found module
	$data[$line] =~ s/--.*//;		#strip any trailing --comment

        if ($data[$line] =~ m/\(/) {		#0x28 is '('
		$pfound = $line;
                $data[$line] =~ s/.*\x28//;	#consume up to first paren
		$line = $entendfound;			#break out of loop
	}
}

#	if couldn't find '(', exit
if ($pfound == -1) {
	print("Unable to instantiate-no occurance of '(' after module keyword.\n");
	exit;
}

#collect port names
my @ports;

for ($line = $pfound; $line < $entendfound; $line++) {
	$data[$line] =~ s/--.*//;		#strip any trailing --comment

	next if not $data[$line] =~ /:.*/;
        push @ports , $data[$line];
}

#print out instantiation
print ("component $file\n");	#print first line
print (" port (\n");		#print second line
my $out= join "\n", @ports;
print ("$out\t\n\t);\nend component;\n"); #print ports and last couple of lines

exit;

#------------------------------------------------------------------------------ 
# Generic Error and Exit routine 
#------------------------------------------------------------------------------

sub dienice {
	my($errmsg) = @_;
	print"$errmsg\n";
	exit;
}


