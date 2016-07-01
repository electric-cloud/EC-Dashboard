use Cwd;
use Data::Dumper;
use File::Spec;

my $portNumber = 3031

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
		system "cd ../../$pluginName/dashing && dashing -d -p $portNumber start" or
			print $fh "couldn't exec dashing: $!";
		# logfile log/thin.log
	} else {  # Promotion from the command line
	}
} elsif ($promoteAction eq 'demote') {
	if(defined $ENV{'QUERY_STRING'}) { # Demotion through UI
		# PID tmp/pids/thin.pid
		system "kill `cat ../../$pluginName/dashing/tmp/pids/thin.pid`" or
			print $fh "Couldn't kill 'thin' process";
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
