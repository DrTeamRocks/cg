#!/usr/bin/perl

package Database::SQLite {
    # Enable errors
    use strict;
    use warnings FATAL => 'all';

    # Load database module
    use DBI;
    use Switch;

    # Class __create function
    sub new {
        my $class = shift;
        my $self = { };
        bless $self, $class;

        return $self;
    }

    # Init database
    sub init
    {
        my $self = shift;
        my %config = @_;

        $self->{dbname} = $config{'database.dbname'};
        $self->{dbuser} = $config{'database.dbuser'};
        $self->{dbpass} = $config{'database.dbpass'};

        my $dsn = "DBI:SQLite:dbname=$self->{dbname}";

        $self->{instanse} = DBI->connect(
            $dsn,
            $self->{dbuser},
            $self->{dbpass},
            { RaiseError => 1 }
        ) or die $DBI::errstr;
    }

    # Make query into database
    sub query
    {
        my $self = shift;
        my $sql = shift;
        my $mode = shift;

        my $request = qq($sql);

        switch($mode) {
            case 'execute' {
                my $response = $self->{instanse}->do($request);
                return 0;
            }
            else {
                my @result = $self->{instanse}->selectall_arrayref($request, { Slice => {} });
                return @result;
            }
        }
    }

    # Close database connection
    sub disconnect
    {
        my $self = shift;

        return $self->{instanse}->disconnect();
    }
}

1;
