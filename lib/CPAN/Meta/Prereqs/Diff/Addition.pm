use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package CPAN::Meta::Prereqs::Diff::Addition;

our $VERSION = '0.001000';

# ABSTRACT: A new dependency

# AUTHORITY

use Moo qw( with has );

has 'requirement' => ( is => ro =>, required => 1 );

with 'CPAN::Meta::Prereqs::Diff::Role::Change';

sub is_addition { return 1 }
sub is_removal  { }
sub is_change   { }

sub describe {
  my ($self) = @_;
  return sprintf q[%s.%s: +%s %s], $self->phase, $self->type, $self->module, $self->requirement;
}

no Moo;

1;

