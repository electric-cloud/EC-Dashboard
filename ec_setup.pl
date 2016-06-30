use Cwd;
use Data::Dumper;
use File::Spec;

my $dir = getcwd;
my $logfile ="";
if(defined $ENV{'QUERY_STRING'}) { # Promotion through UI
	$logfile = "/tmp/log.txt";
} else {
	$logfile = "$ENV{'TEMP'}/log.txt";
}
open(my $fh, '>', $logfile) or die "Could not open file '$logfile' $!";
print $fh "Plugin Name: $pluginName\n";
print $fh "Current directory: $dir\n";

if ($promoteAction eq 'promote') {
	local $/ = undef;
	if(defined $ENV{'QUERY_STRING'}) { # Promotion through UI
		exec "cd ../../$pluginName/dashing;(dashing start &> /tmp/dashing.log) &" 
			or print $fh "couldn't exec dashing: $!";
	} else {  # Promotion from the command line
	}
} elsif ($promoteAction eq 'demote') {
	if(defined $ENV{'QUERY_STRING'}) { # Demotion through UI
		`killall bundle`;
	} else {  # Promotion from the command line
	}
}

close $fh;

# TODO: create log file output property
open LOGFILE, $logfile or die "Couldn't open file: $!";
my $logFileContent = <LOGFILE>;
my $propertyResponse = $commander->setProperty("/plugins/$pluginName/projects/logfile",
			{value=>$logFileContent}
	);
close LOGFILE;
