use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package CPAN::Meta::Prereqs::Diff::Downgrade;

our $VERSION = '0.001000';

# ABSTRACT: A dependency which changes its requirements to an older version

# AUTHORITY

use Moo qw( with has extends );

extends 'CPAN::Meta::Prereqs::Diff::Change';

sub is_downgrade { return 1 }

sub describe {
  my ($self) = @_;
  return sprintf q[%s.%s: vvv %s %s -> %s], $self->phase, $self->type, $self->module, $self->old_requirement,
    $self->new_requirement;
}

no Moo;

1;

