#! /usr/bin/perl
use Modern::Perl;
use Gearman::Worker;

my $baz = sub {
	my $job = shift;
	my $value = $job->arg;
	return $value * 1000;
};

my $worker = Gearman::Worker->new;
$worker->job_servers('192.168.42.102');
$worker->register_function(baz => $baz);
$worker->work while 1;

