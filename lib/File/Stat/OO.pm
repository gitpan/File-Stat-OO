package File::Stat::OO;
use warnings;
use strict;
use base qw(Class::Accessor);
use DateTime;
our @stat_keys =
    qw(dev ino mode nlink uid gid rdev size atime mtime ctime blksize blocks);

File::Stat::OO->mk_accessors(qw(file use_datetime), @stat_keys);

=head1 NAME

File::Stat::OO - OO interface for accessing file status attributes

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use File::Stat::OO;

    my $foo = File::Stat::OO->new({file => '/etc/password'});
    $foo->stat; # stat file specified at instantiation time
    print $foo->size;
    print $foo->mtime; # modification time in epoch seconds

or inflate epoch seconds into DateTime objects

    my $foo = File::Stat::OO->new();
    $foo->use_datetime(1);
    $foo->stat('/etc/password'); # pass file name to the stat method
    print $foo->mtime; # returns DateTime object not an epoch
    print $foo->mtime->epoch; # epoch seconds

=head1 Methods

=head2 stat

Generate stat information. Takes an optional filename parameter

=cut

sub stat {
    my $self = shift;
    $self->file($_[0]) if ($_[0]);
    die "No such file: " . $self->file unless -e $self->file;

    my @file_stat = stat($self->file);
    my $counter   = 0;

    foreach my $stat (@stat_keys) {
        if ($stat =~ /^[a|m|c]time$/ && $self->use_datetime) {
            $self->$stat(
                DateTime->from_epoch(
                    epoch     => $file_stat[$counter++],
                    time_zone => 'local'
                )
            );
        } else {
            $self->$stat($file_stat[$counter++]);
        }
    }
}

=head2 use_datetime

If set, invocations of stat will record times as DatetTime objects rather than
epoch seconds

=head2 dev

device number of filesystem

=head2 ino

inode number

=cut

=head2 mode

file mode type and permissions

=cut

=head2 nlink

number of (hard) links to the file

=cut

=head2 uid

numeric user ID of the file's owner

=cut

=head2 gid

numeric group ID of the file's owner

=cut

=head2 rdev

the device identifier (special files only)

=cut

=head2 size

size of the file in bytes

=cut

=head2 atime

last access time (DateTime object)

=cut

=head2 mtime

last modify time (DateTime object)

=cut

=head2 ctime

inode chane time (DateTime object)

=cut

=head2 blksize

preferred blocksize for file system I/O

=cut

=head2 blocks

actual number of blocks allocated

=cut

=head1 AUTHOR

Dan Horne, C<< <dhorne at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-file-stat-oo at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=File-Stat-OO>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc File::Stat::OO

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/File-Stat-OO>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/File-Stat-OO>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=File-Stat-OO>

=item * Search CPAN

L<http://search.cpan.org/dist/File-Stat-OO>

=back

=head1 SEE ALSO

C<File::stat>

=head1 COPYRIGHT & LICENSE

Copyright 2008 Dan Horne, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;    # End of File::Stat::OO
