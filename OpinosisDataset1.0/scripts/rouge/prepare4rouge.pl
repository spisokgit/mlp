#!/usr/bin/perl

# Copyright © 2010 Kavita Ganesan www.kavita-ganesan.com/
# Date:        04/06/2010
# Author:      Kavita Ganesan (kganes2@illinois.edu)
#   This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

#Script that prepares for ROUGE evaluation using a jackniffing procedure. If you do not want jackniffing, you may have to modify this script a little, however if you have +
#script generates :
#			<system> directory where all the formatted system and baseline summaries are dumped
#			<model>   directory where all the formatted reference summaries are dumped.
#			settings.xml - specifies which system summary uses which gold standard summaries for evaluation. This is automatically inferred by the file name prefixes.
#
#This script needs location of directory containing baseline summaries, gold standard summaries and system summaries. So please change the variables accordingly below.
#The filename prefix would indicate the summarization task. For example, 
#<performance_honda_accord>.baseline, 
#<performance_honda_accord>.gold, 
#<performance_honda_accord>.system1  
#
#
# Variables you need to set:
#  my $ROUGE_HOME = "<WHERE TO GENERATE THE RESULTS>";
#  my $DIR_SYSTEM="<directory where system generated files are stored>" - note that within this directory, the results of each system should be stored in a separate folder.
#  So if you have summaries from 3 different systems, there should be 3 folders each identified by the system name. Inside these folders, you would have the summary files like <performance_honda_accord>.system1..etc. ;
#  my $DIR_GOLD="<directory containing reference summaries>" - it is assumed that each set of reference summary, is within a separate folder. So if you have 4 reference summaries for topic  xyz, the folder name would be xyz, and within xyz you may have xyz.1.gold, xyz.2.gold...xyz.4.gold;
#  my $DIR_BASE="directory containing baseline summaries>" -  here it is assumed that you have only 1 baseline summary per summarization task. So, in this directory you can directly have <topicname>.baseline files ;
#
# @SEE  examples/prepare4rougejk/ for sample input and output to get a better idea. Instructions on how to use rouge can be found here http://kavita-ganesan.com/rouge-howto
#
#

use strict;



my $ROUGE_HOME = "OUTPUT";
my $DIR_SYSTEM="summaries-opinosisNODUPELIM";
my $DIR_GOLD="summaries-gold";
my $DIR_BASE="summaries-base";

`rm -r $ROUGE_HOME `;


`mkdir $ROUGE_HOME `;
`mkdir $ROUGE_HOME/systems `;
`mkdir $ROUGE_HOME/models `;

my $systemFile = shift;
my @models = @ARGV;
my @sentences = ();

opendir(GOLD, "$DIR_GOLD") || die("Cannot open directory"); 
my @thegoldfiles= readdir(GOLD);
#gold standard files are inside a directory
foreach my $goldir (@thegoldfiles) 
{
	my $thepath="$DIR_GOLD/$goldir";

	if ((-d $thepath) && ($goldir ne '.') && ($goldir ne '..') ) {
		
		opendir(GOLDFILES, "$DIR_GOLD/$goldir") || die("Cannot open directory"); 
		my @thefiles= readdir(GOLDFILES);
		
		foreach my $file (@thefiles) 
		{
			if( ($file ne '.') && ($file ne '..')){
				my $abspath="$thepath/$file";
				@sentences = &open_file($abspath);
				open (MODEL,">$ROUGE_HOME/models/$file.html");
				print MODEL "<html>
				<head>
				<title>$file.html</title>
				</head>
				<body bgcolor=\"white\">\n";
				my $count = 1;
				foreach my $j (0..$#sentences) {
						print MODEL "<a name=\"$count\">[$count]</a> <a href=\"#$count\" id=$count>";
						print MODEL $sentences[$j];
						print MODEL "</a>\n";
						$count++;
				}
				print MODEL "</body>
									 </html>\n";
			close MODEL;
			}
			}
		}
	}


#write baseline dirs
opendir(BASE, "$DIR_BASE") || die("Cannot open directory"); 
my @thebasefiles= readdir(BASE);
#gold standard files are inside a directory
foreach my $file (@thebasefiles) 
{
	print $file;
	if( ($file ne '.') && ($file ne '..')){
		my $abspath="$DIR_BASE/$file";
		open (SYSTEM, ">$ROUGE_HOME/systems/$file.html");
		print SYSTEM "<html>
			<head>
			<title>$file.html</title>
			</head>
			<body bgcolor=\"white\">\n";
	
		my $count = 1;
		@sentences = &open_file($abspath);
		foreach my $i (0..$#sentences) {
			print SYSTEM "<a name=\"$count\">[$count]</a> <a href=\"#$count\" id=$count>";
			print SYSTEM $sentences[$i];
			print SYSTEM "</a>\n";
			$count++;
		}
		print SYSTEM "</body>
			</html>\n";
		close SYSTEM;
	}
}

opendir(OPINO, "$DIR_SYSTEM") || die("Cannot open directory"); 
my @theopinofiles= readdir(OPINO);
#gold standard files are inside a directory
foreach my $opinodir (@theopinofiles) 
{
	my $thepath="$DIR_SYSTEM/$opinodir";

	if ((-d $thepath) && ($opinodir ne '.') && ($opinodir ne '..') ) {
		
		opendir(OPINOFILES, "$DIR_SYSTEM/$opinodir") || die("Cannot open directory"); 
		my @thefiles= readdir(OPINOFILES);
		
		foreach my $file (@thefiles) 
		{
			if( ($file ne '.') && ($file ne '..')){
				my $abspath="$thepath/$file";
				@sentences = &open_file($abspath);

				open (SYSTEM, ">$ROUGE_HOME/systems/$file.html");
				print SYSTEM "<html>
				<head>
				<title>$file.html</title>
				</head>
				<body bgcolor=\"white\">\n";
	
				my $count = 1;
				
				foreach my $i (0..$#sentences) {
					print SYSTEM "<a name=\"$count\">[$count]</a> <a href=\"#$count\" id=$count>";
					print SYSTEM $sentences[$i];
					print SYSTEM "</a>\n";
					$count++;
				}
				print SYSTEM "</body>
				</html>\n";
				close SYSTEM;
				}
			}
		}
}

my $evalID = 1;
my $fileid=0;

`rm $ROUGE_HOME/settings.xml`;


opendir(GOLD, "$DIR_GOLD") || die("Cannot open directory"); 
my @thegoldfiles= readdir(GOLD);
#gold standard files are inside a directory
foreach my $file (@thegoldfiles) 
{
	if ((-d "$DIR_GOLD/$file") && ($file ne '.') && ($file ne '..') ) {
	
	my @models;
	my @peers;
	print "====================$file=================";
	opendir DIR, "$ROUGE_HOME/models";
	@models = grep { /$file.*/} readdir DIR;
	closedir DIR;

	opendir DIR, "$ROUGE_HOME/systems";
	@peers = grep { /$file.*/} readdir DIR;
	closedir DIR;

	my $id=1;

	$fileid++;

	my $msize= @models;
	

	open (CONFIG, ">$ROUGE_HOME/settings$fileid.xml");
	print CONFIG "<ROUGE_EVAL version=\"1.5.5\">\n";
	
	my $count=0;
	my $limit=$msize-1;
	foreach $count (0..$limit) 
	{
		print CONFIG "<EVAL ID=\"$evalID\">\n";
		print CONFIG "<PEER-ROOT>systems</PEER-ROOT>\n";
		print CONFIG "<MODEL-ROOT>models</MODEL-ROOT>\n";
		print CONFIG "<INPUT-FORMAT TYPE=\"SEE\"></INPUT-FORMAT>\n<PEERS>";
		my $id=1;
		foreach my $peer (@peers) 
		{
			my $pid=$id;
			if($peer =~ m/.*baseline.*html/ig){
				$pid="baseline";
		}

			if($peer =~ m/.*system.*html/ig){
				$pid="";
				my @tokens=split('\.',$peer);
				$pid=$pid.$tokens[1];
			}
			print CONFIG "\n<P ID=\"$pid\">$peer</P>";
			$id++;
		}	
		print CONFIG "</PEERS>\n
		<MODELS>\n";
		foreach my $k (0..$limit) 
		{
			if($k ne $count) {
				my $id=$k+1;
				my $model=$models[$k];
				print CONFIG "\n<M ID=\"$id\">$model</M>";
				$id++;
			}
		}

	print CONFIG "\n</MODELS>
	</EVAL>\n";
	$evalID++;
	}
	 #done eval
	print CONFIG "\n</ROUGE_EVAL>";
	close CONFIG;
	
	}
}



#====================================
sub open_file{
my $file = shift;

my @sents = ();

local( $/ ) = undef;

open(FILE, "$file") or die "can't find the file: $file. \n";

my $input = <FILE>;

close FILE;

if ($input =~/DOCTYPE DOCUMENT SYSTEM/){
   my $text = "";
   $input =~/<TEXT>(.*)<\/TEXT>/s;
   $text = $1;
   @sents = split /[\n\r]/, $text;
}

else {

@sents = split /[\n\r]/, $input;

foreach my $s (@sents){
   $s =~s/^\[\d+\]\s+(.*)/$1/;
  }
}
return @sents;
}

