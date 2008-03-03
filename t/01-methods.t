#!perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use Test::More;

use File::Stat::OO;

if($^O =~ /Win/) {

	plan tests => 27;

} else {

	plan tests => 32;

}



my $obj = File::Stat::OO->new;

my $class = 'File::Stat::OO';



isa_ok($obj, $class);

my @methods = (qw/new file use_datetime/, @File::Stat::OO::stat_keys); 



foreach my $m (@methods) {

	ok($obj->can($m), "$class->can('$m')");

}

$obj->stat($0);

foreach my $m (@File::Stat::OO::stat_keys) {
	next if (($^O =~ /Win/) && grep(/^$m$/, (qw/ino uid gid blksize blocks/)));
        next if $m eq 'rdev';
	ok($obj->$m, "Method $m");
}

$obj->use_datetime(1);
$obj->stat($0);

foreach my $m (qw/atime ctime mtime/) {
	my $date_obj = $obj->$m;
	isa_ok($date_obj, 'DateTime');
}

