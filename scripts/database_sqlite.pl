#!/usr/bin/perl

# Enable errors
use strict;
use warnings FATAL => 'all';

# Main classes
use Config::Simple;
use File::Basename;
use Data::Dumper;

# Project libs path
use lib dirname (__FILE__).'/libs/';

# Project classes
use Database::SQLite;

# Get config and save him into array
my %config = Config::Simple->new(dirname (__FILE__).'/config.ini')->vars();

# Database
my $db = Database::SQLite->new();
$db->init(%config);
# Insert value
#$db->query("insert into COMPANY (id, name, age) VALUES ('1', 'Name', '12');", 'execute');
#$db->query("insert into COMPANY (id, name, age) VALUES ('2', 'Name2', '12');", 'execute');
#$db->query("insert into COMPANY (id, name, age) VALUES ('3', 'Name3', '12');", 'execute');
#$db->query("insert into COMPANY (id, name, age) VALUES ('8', 'Name8', '12');", 'execute');
# Get value
my @result = $db->query("SELECT * FROM COMPANY;");
print Dumper(@result);
$db->disconnect();
