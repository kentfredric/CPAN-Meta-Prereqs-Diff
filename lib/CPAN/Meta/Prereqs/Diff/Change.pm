use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package CPAN::Meta::Prereqs::Diff::Change;

our $VERSION = '0.000000';

# ABSTRACT: A dependency which changes its requirements

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

use Moo qw( with has );

has 'old_requirement' => ( is => ro =>, required => 1 );
has 'new_requirement' => ( is => ro =>, required => 1 );

with 'CPAN::Meta::Prereqs::Diff::Role::Change';

sub is_addition  { }
sub is_removal   { }
sub is_change    { 1 }
sub is_upgrade   { }
sub is_downgrade { }

sub describe {
  return sprintf q[%s.%s: ~%s %s -> %s], $_[0]->phase, $_[0]->type, $_[0]->module, $_[0]->old_requirement, $_[0]->new_requirement;
}

no Moo;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

CPAN::Meta::Prereqs::Diff::Change - A dependency which changes its requirements

=head1 VERSION

version 0.000000

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
