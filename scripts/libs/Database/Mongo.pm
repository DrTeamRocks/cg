#!/usr/bin/perl

package Database::Mongo {
    # Enable errors
    use strict;
    use warnings FATAL => 'all';

    # Load database module
    use Mango;
    use Switch;

    # Class __create function
    sub new {
        my $class = shift;
        my $mode = shift;
        my $self = { };
        bless $self, $class;

        # If database is defined
        if (defined($mode) && $mode ne "") {
            # Save into $self
            $self->{table} = $mode;
        }

        return $self;
    }

    # Init database
    sub init
    {
        my $self = shift;
        my %config = @_;
        my $mango = '';

        $self->{dbhost} = $config{'database.dbuser'};
        $self->{dbport} = $config{'database.dbpass'};
        $self->{dbname} = $config{'database.dbname'};

        # If user and user pass are defined
        if (defined($config{'database.dbuser'}) && defined($config{'database.dbpass'})) {
            $self->{dbuser} = $config{'database.dbuser'};
            $self->{dbpass} = $config{'database.dbpass'};
            # Use the mango driver
            $mango = Mango->new(
                'mongodb://',
                $self->{dbuser}, ':', $self->{dbpass},
                '@',
                $self->{dbhost}, ':', $self->{dbport}
            );
        } else {
            # Use the mango driver
            $mango = Mango->new(
                'mongodb://',
                $self->{dbhost}, ':', $self->{dbport}
            );
        }

        $self->{instanse} = $mango->db($self->{dbname});
    }

    # Open collection
    sub query
    {
        my $self = shift;
        my $request = shift;
        my $mode = shift;

        # Set the collection
        my $worker = $self->{instanse}->collection($self->{table});

        switch($mode) {
            case 'insert' {
                $worker->insert($request);
                return 0;
            }
            case 'update' {
                $worker->update($request);
                return 0;
            }
            case 'remove' {
                $worker->remove($request);
                return 0;
            }
            else {
                my @result = $worker->find($request);
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
