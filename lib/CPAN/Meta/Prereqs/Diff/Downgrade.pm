use 5.006;    # our
use strict;
use warnings;

package CPAN::Meta::Prereqs::Diff::Downgrade;

our $VERSION = '0.001004';

# ABSTRACT: A dependency which changes its requirements to an older version

# AUTHORITY

use Moo qw( with has extends );

extends 'CPAN::Meta::Prereqs::Diff::Change';

=method C<is_downgrade>

  returns true

=cut

sub is_downgrade { return 1 }

=method C<describe>

  $object->describe();

  # runtime.requires: vvv ExtUtils::MakeMaker 5.1 -> 5.0

=cut

sub describe {
  my ($self) = @_;
  return sprintf q[%s.%s: vvv %s %s -> %s], $self->phase, $self->type, $self->module, $self->old_requirement,
    $self->new_requirement;
}

no Moo;

1;

