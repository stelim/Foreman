#! /usr/bin/env perl
use Modern::Perl '2013';
use Gearman::Client;
use Data::Dumper;

say "connect to jobserver ...";
my $client = Gearman::Client->new;
$client->job_servers('127.0.0.1');


say "running a single task";
my $result_ref = $client->do_task("foo", "hello world!");
say "hello world! => $$result_ref";

$result_ref = $client->do_task("bar" => 2);
say "2 => $$result_ref";

my $completed = sub {
    my $params = shift;
    say $$params;
};

say "running more tasks on one worker";
my $task_set = $client->new_task_set;
for my $number (1..10) {
    $task_set->add_task(bar => $number, {
        on_complete => $completed
    });
}
$task_set->add_task(foo => "foobar", {
    high_priority => 1,
    on_complete => $completed
});
$task_set->add_task(bar => 100, {
    on_complete => $completed
});



say "is something done? - no?";

$task_set->wait;
say "ok, but now it should be done!";