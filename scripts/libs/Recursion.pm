#!/usr/bin/perl

package Recursion {
    # Enable errors
    use strict;
    use warnings FATAL => 'all';

    # Enable MD5 support
    use Digest::CRC;

    # File info
    use File::stat;

    # Class __create function
    sub new {
        my $class = shift;
        my $db = shift;
        my $table = shift;
        my $self = { };

        bless $self, $class;

        # If database is defined
        if (defined($db) && $db ne "") {
            # Save into $self
            $self->{db} = $db;
        }

        # Save crc into $self
        $self->{crc} = Digest::CRC->new(type => "crc16");

        return $self;
    }

    # Method for recursive analyze
    sub init
    {
        my $self = shift;
        my $dir = shift;
        my $verbose = shift;

        # Open current directory and create files array
        opendir DIR, $dir or return;
        my @contents = map "$dir/$_", sort grep !/^\.\.?$/, readdir DIR;
        closedir DIR;

        # Analyze the array
        foreach (@contents)
        {
            # If file (and not symlink) - get hash
            if (-f $_ && !-l $_)
            {
                # Fileinfo
                my $size = stat($_)->size;
                my $mtime = stat($_)->mtime;

                # Generate md5sum
                $self->{crc}->add($size.' / '.$mtime);
                my $digest = $self->{crc}->digest;

                # If need more info
                if ($verbose eq 1) {
                    print "F: ".$_."\n";
                    print $size."\n";
                    print $mtime."\n";
                    print $digest."\n\n";
                }

                # Get value
                my @result = $self->{db}->query("SELECT * FROM COMPANY;");
            }

            # If dir - get mtime and scan deep
            if (-d $_)
            {
                # Fileinfo
                my $mtime = stat($_)->mtime;

                # If need more info
                if ($verbose eq 1) {
                    print "D: ".$_."\n";
                    print $mtime."\n\n";
                }

                # Scan files in dir
                $self->init($_);
            }

            # If link - get mtime and target
            if (-l $_)
            {
                # Fileinfo
                my $mtime = stat($_)->mtime;
                my $target = readlink($_);

                # If need more info
                if ($verbose eq 1) {
                    print "L: ".$_."\n";
                    print $target."\n";
                    print $mtime."\n\n";
                }
            }

        }
    }
}

1;
