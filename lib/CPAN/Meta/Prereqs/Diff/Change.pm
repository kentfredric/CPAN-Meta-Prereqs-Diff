use 5.006;    # our
use strict;
use warnings;

package CPAN::Meta::Prereqs::Diff::Change;

our $VERSION = '0.001004';

# ABSTRACT: A dependency which changes its requirements

# AUTHORITY

use Moo qw( with has );

=attr C<old_requirement>

=attr C<new_requirement>

=cut

has 'old_requirement' => ( is => ro =>, required => 1 );
has 'new_requirement' => ( is => ro =>, required => 1 );

with 'CPAN::Meta::Prereqs::Diff::Role::Change';

=method C<is_addition>

=method C<is_removal>

=method C<is_change>

  returns true

=method C<is_upgrade>

=method C<is_downgrade>

=cut

sub is_addition  { }
sub is_removal   { }
sub is_change    { return 1 }
sub is_upgrade   { }
sub is_downgrade { }

=method C<describe>

  $object->describe();

  # runtime.requires: ~ExtUtils::MakeMaker < 5.0 -> > 5.1

=cut

sub describe {
  my ($self) = @_;
  return sprintf q[%s.%s: ~%s %s -> %s], $self->phase, $self->type, $self->module, $self->old_requirement, $self->new_requirement;
}

no Moo;

1;

