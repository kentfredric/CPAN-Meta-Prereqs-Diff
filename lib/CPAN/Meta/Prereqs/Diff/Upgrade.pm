use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package CPAN::Meta::Prereqs::Diff::Upgrade;

our $VERSION = '0.000000';

# ABSTRACT: A dependency which changes its requirements to a newer version

our $AUTHORITY = 'cpan:KENTNL'; # AUTHORITY

use Moo qw( with has );

extends 'CPAN::Meta::Prereqs::Diff::Change';

sub is_upgrade { 1 }

sub describe {
  return sprintf q[%s.%s: ^^^ %s %s -> %s], $_[0]->phase, $_[0]->type, $_[0]->module, $_[0]->old_requirement,
    $_[0]->new_requirement;
}

no Moo;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

CPAN::Meta::Prereqs::Diff::Upgrade - A dependency which changes its requirements to a newer version

=head1 VERSION

version 0.000000

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
