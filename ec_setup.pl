use Cwd;
use Data::Dumper;
use File::Spec;

my $portNumber = 3030;

my $dir = getcwd;
my $logfile ="";
if(defined $ENV{'QUERY_STRING'}) { # Promotion through UI
	$logfile = "../../$pluginName/ec_setup.log";
} else {
	$logfile = "$ENV{'TEMP'}/log.txt";
}
open(my $fh, '>', $logfile) or die "Could not open file '$logfile' $!";
print $fh "Plugin Name: $pluginName\n";
print $fh "Current directory: $dir\n";

if ($promoteAction eq 'promote') {
	local $/ = undef;
	if(defined $ENV{'QUERY_STRING'}) { # Promotion through UI
		my $dashingCommand = "cd ../../$pluginName/dashing && dashing start -d -p $portNumber &> /dev/null";
		print $fh "Starting dashing: $dashingCommand\n";
		# logfile log/thin.log
		system $dashingCommand or
			print $fh "Couldn't exec dashing: $!\n";
	} else {  # Promotion from the command line
	}
} elsif ($promoteAction eq 'demote') {
	if(defined $ENV{'QUERY_STRING'}) { # Demotion through UI
		# PID tmp/pids/thin.pid
		system "kill `cat ../../$pluginName/dashing/tmp/pids/thin.pid`" or
			print $fh "Couldn't kill 'thin' process\n";
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
