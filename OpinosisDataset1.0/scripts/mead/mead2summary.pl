
## This script essentially summarizes each cluster directory. All you need to provide the root folder containing all the cluster directories.
## This is the next logical step after running doc2mead.pl. 
## Make sure you set MEAD_HOME as follows: export MEAD_HOME=/<absolute path to mead directory>/. 
## MEAD_HOME is a variable used by this script.

opendir(IMD, ".") || die("Cannot open directory");

$cmd="mkdir ../results; rm -r ../results/*";
system($cmd);

@thefiles= readdir(IMD); 

foreach $file(@thefiles){
	
	if( ($file ne '.') &&  ($file ne '..')) {
		$cmd="perl ".$ENV{MEAD_HOME}."bin/mead.pl -classifier 'perl  $ENV{MEAD_HOME}bin/default-classifier.pl Length 3 Centroid 4 Position 0' -absolute 3  $file > ../results/$file.baseline";
		
		print $cmd;
		print "\n";
		system($cmd);
	}
}