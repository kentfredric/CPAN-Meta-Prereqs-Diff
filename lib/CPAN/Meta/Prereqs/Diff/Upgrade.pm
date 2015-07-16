use 5.006;    # our
use strict;
use warnings;

package CPAN::Meta::Prereqs::Diff::Upgrade;

our $VERSION = '0.001003';

# ABSTRACT: A dependency which changes its requirements to a newer version

# AUTHORITY

use Moo qw( with has extends );

extends 'CPAN::Meta::Prereqs::Diff::Change';

=method C<is_upgrade>

  returns true

=cut

sub is_upgrade { return 1 }

=method C<describe>

  $object->describe();

  # runtime.requires: ^^^ ExtUtils::MakeMaker 5.0 -> 5.1

=cut

sub describe {
  my ($self) = @_;
  return sprintf q[%s.%s: ^^^ %s %s -> %s], $self->phase, $self->type, $self->module, $self->old_requirement,
    $self->new_requirement;
}

no Moo;

1;

