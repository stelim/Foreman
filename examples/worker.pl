#! /usr/bin/env perl
use Modern::Perl '2013';
use Gearman::Worker;

use Data::Dumper;




my $foo = sub {
    my $job = shift;
    return reverse $job->arg;
};

my $bar = sub {
    my $job = shift;
    my $value = $job->arg;

    sleep 1;
    $job->set_status(1,3);
    sleep 2;
    $job->set_status(2,3);

    return $value;
};


my $worker = Gearman::Worker->new;
$worker->job_servers('127.0.0.1');
$worker->register_function(foo => $foo);
$worker->register_function(bar => $bar);
$worker->work while 1;