use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package CPAN::Meta::Prereqs::Diff::Change;

our $VERSION = '0.001000';

# ABSTRACT: A dependency which changes its requirements

# AUTHORITY

use Moo qw( with has );

has 'old_requirement' => ( is => ro =>, required => 1 );
has 'new_requirement' => ( is => ro =>, required => 1 );

with 'CPAN::Meta::Prereqs::Diff::Role::Change';

sub is_addition  { }
sub is_removal   { }
sub is_change    { return 1 }
sub is_upgrade   { }
sub is_downgrade { }

sub describe {
  my ($self) = @_;
  return sprintf q[%s.%s: ~%s %s -> %s], $self->phase, $self->type, $self->module, $self->old_requirement, $self->new_requirement;
}

no Moo;

1;

