use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package CPAN::Meta::Prereqs::Diff::Removal;

our $VERSION = '0.001000';

# ABSTRACT: An unneeded dependency

# AUTHORITY

use Moo qw( with has );

has 'requirement' => ( is => ro =>, required => 1 );

with 'CPAN::Meta::Prereqs::Diff::Role::Change';

=method C<is_addition>

=method C<is_removal>

  returns true

=method C<is_change>

=cut

sub is_addition { }
sub is_removal  { return 1 }
sub is_change   { }

=method C<describe>

  $object->describe();

  # runtime.requires: -ExtUtils::MakeMaker 5.0

=cut

sub describe {
  my ($self) = @_;
  return sprintf q[%s.%s: -%s %s], $self->phase, $self->type, $self->module, $self->requirement;
}

no Moo;

1;

