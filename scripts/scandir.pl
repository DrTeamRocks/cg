#!/usr/bin/perl

# Enable errors
use strict;
use warnings FATAL => 'all';

# Main classes
use Config::Simple;
use File::Basename;
use Data::Dumper;
use Switch;

# Project libs path
use lib dirname (__FILE__).'/libs/';

# Project classes
use Recursion;

# Get config and save him into array
my %config = Config::Simple->new(dirname (__FILE__).'/config.ini')->vars();

# Database initial variables
my $db = '';
my $mode = 'full';
# Select database type from config
switch(lc($config{'database.dbtype'})) {
    case 'mongo' {
        print "INF: Enable Mongo support\n";
        use Database::Mongo;
        $db = Database::Mongo->new($mode);
    }
    case 'sqlite' {
        print "INF: Enable SQLite support\n";
        use Database::SQLite;
        $db = Database::SQLite->new($mode);
    }
    else {
        print "ERR: Database type is not set\n";
        exit;
    }
}
$db->init(%config);

# Run command
my $recursion = Recursion->new($db);
$recursion->init($config{'main.scandir'}, 1);
