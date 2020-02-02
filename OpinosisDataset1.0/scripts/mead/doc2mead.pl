## Assuming you are in the root folder where the files(directories) to be summarized reside, this script will generate the corresponding clusters/docsent files that will be used by mead.
## Make sure that each file to be summarized is kept in a separate folder.  


## before running script, first make sure you set PERL5LIB as follows:
##    export PERL5LIB=$PATH:/<absolute path>/mead/bin/addons/formatting/ 
## then you need to set the absolute path of the dtd directory variable $DTD_DIR on line 18 of MEAD ADDONS UTIL.pm I am not sure what exactly this does, but I just set it before running the ## text2cluster.pl $DTD_DIR ="<myabspath>/mead/dtd";
## finally make sure you set MEAD_HOME as follows: export MEAD_HOME=/<absolute path to mead directory>/. 
## MEAD_HOME is a variable used by this script.

opendir(IMD, ".") || die("Cannot open directory");



@thefiles= readdir(IMD); 

foreach $file(@thefiles){
	
	if( ($file ne '.') &&  ($file ne '..')) {
		$cmd="perl ".$ENV{MEAD_HOME}."bin/addons/formatting/text2cluster.pl $file";
		print $cmd;
		print "\n";
		system($cmd);
	}
}