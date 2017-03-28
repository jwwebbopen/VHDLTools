#!/usr/bin/perl

#------------------------------------------------------------------------------ 
# VHDL Module Template
#	by Jeremy Webb
#	
#	Rev 1.4, April 1, 2007
#
#	This utility is intended to make creating new VHDL modules easier using
#	a good editor, such as VI.
#	
#	As long as you set the top line to correctly point to your perl binary,
#	and place this script in a directory in your path, you can invoke it from VI.
#	Simply use the !! command and call this script with the filename you wish
#	to instantiate.  This script will create a new text file called 
#	"new_module_name.vhd" when you type the following command:
#	
#		!! vhdl_mod.pl new_module_name.vhd
#		
#	The script will generate the empty VHDL template for you. 
#	Note:  "new_module_name.vhd" is the name of the new VHDL file and can 
#	be anything you like. 
#
#	Revision History:
#		1.0	11/14/2004	Initial release
#               1.1     12/2/2004       Changed the username grab to use getlogin();
#               1.2     06/01/2005      Changed Confidential in header.
#               1.3     06/30/2006      Changed copyright date to update automatically.
#               1.4     04/01/2007      Changed company header.
#
#	Please report bugs, errors, etc.
#------------------------------------------------------------------------------

#	Retrieve command line argument
#

use strict;

my $file = $ARGV[0];


# check to see if the user entered a file name.
die "syntax: [perl] vhdl_mod.pl new_file.vhd\n" if ($file eq "");


# check to make sure that the file doesn't exist.
die "Oops! A file called '$file' already exists.\n" if -e $file;
open(my $inF, ">", $file);

# Strip the .v from the file name and use for the module name:
$file =~ s/\.vhd$//;
# Make Date int MM/DD/YYYY
my $year      = 0;
my $month     = 0;
my $day       = 0;
($day, $month, $year) = (localtime)[3,4,5];


# Grab username from PC:
my $author= "$^O user";
if ($^O =~ /mswin/i)
{ 
  $author= $ENV{USERNAME} if defined $ENV{USERNAME};
}
else
{ 
  $author = getlogin();
}
#Module Template:
printf($inF "-------------------------------------------------------------------------------\n");
printf($inF "--                                                     Revision: 1.1 \n");
printf($inF "--                                                     Date: %02d/%02d/%04d \n", $month+1, $day, $year+1900);
printf($inF "-------------------------------------------------------------------------------\n");
printf($inF "--\t\t\t\t My Company Confidential Copyright © %04d My Company, Inc.\n", $year+1900);
printf($inF "--\n");
printf($inF "--   File name :  $file.vhd\n");
printf($inF "--   Title     :  ?????\n");
printf($inF "--   Module    :  $file\n");
printf($inF "--   Author    :  $author\n");
printf($inF "--   Purpose   :  ?????\n");
printf($inF "--\n");
printf($inF "--   Roadmap   :\n");
printf($inF "-------------------------------------------------------------------------------\n");
printf($inF "--   Modification History :\n");
printf($inF "--\tDate\t\tAuthor\t\tRevision\tComments\n");
printf($inF "--\t%02d/%02d/%04d\t$author\tRev A\t\tCreation\n", $month+1, $day, $year+1900);
printf($inF "-------------------------------------------------------------------------------\n");
printf($inF "\n");
printf($inF "Library IEEE;\n");
printf($inF "use IEEE.STD_LOGIC_1164.all;\n");
printf($inF "use IEEE.std_logic_unsigned.all;\n");
printf($inF "use IEEE.std_logic_arith.all;\n");
printf($inF "use IEEE.Numeric_STD.all;\n");
printf($inF "\n");
printf($inF "library work;\n");
my $new_text = join "_", $file, "pkgs.all";
printf($inF "use work.$new_text;\n");
printf($inF "\n");
printf($inF "\n");
printf($inF "-- Declare module entity. Declare module inputs, inouts, and outputs.\n");
printf($inF "entity $file is\n");
printf($inF "\tport\t(\n");
printf($inF "\t\t-- *** Inputs ***\n");
printf($inF "\t\t-- CLK signals ----------------------------\n");
printf($inF "\t\tclk     : in    std_logic;\t\t-- System Clock (90MHz).\n");
printf($inF "\t\trst_n   : in    std_logic;\t\t-- Reset. (Active Low).\n");
printf($inF "\n");
printf($inF "\n");
printf($inF "\t\toutput1 : out   std_logic;                      -- Output 1\n");
printf($inF "\t\toutput2 : out   std_logic_vector (2 downto 0)   -- Ouptut 2\n");
printf($inF "); \n");
printf($inF "end $file;\n");
printf($inF "\n");
printf($inF "-- Begin module architecture/code.\n");
printf($inF "architecture behave of $file is\n");
printf($inF "\n");
printf($inF "-- Local parameter, wire, and register declarations go here.\n");
printf($inF "-- N/A\n");
printf($inF "-- general signals\n");
printf($inF "-- N/A\n");
printf($inF "\n");
printf($inF "begin\n");
printf($inF "\n");
printf($inF "-- Insert Processes and code here.\n");
printf($inF "\n");
printf($inF "end behave; -- architecture\n");
printf($inF "\n");
printf($inF "\n");
my $new_text2 = join "_", $file, "cfg";
printf($inF "configuration $new_text2 of $file is\n");
printf($inF "for behave\n");
printf($inF "end for;\n");
printf($inF "end $new_text2;\n");

close(inF); 

print("\nThe script has finished successfully! You can now use $file.vhd.\n\n");

 
exit;
 
#------------------------------------------------------------------------------ 
# Generic Error and Exit routine 
#------------------------------------------------------------------------------
 
sub dienice {
	my($errmsg) = @_;
	print"$errmsg\n";
	exit;
}


