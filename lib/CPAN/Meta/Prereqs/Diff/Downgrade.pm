use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package CPAN::Meta::Prereqs::Diff::Downgrade;

our $VERSION = '0.001000';

# ABSTRACT: A dependency which changes its requirements to an older version

# AUTHORITY

use Moo qw( with has );

extends 'CPAN::Meta::Prereqs::Diff::Change';

sub is_upgrade { 1 }

sub describe {
  return sprintf q[%s.%s: vvv %s %s -> %s], $_[0]->phase, $_[0]->type, $_[0]->module, $_[0]->old_requirement,
    $_[0]->new_requirement;
}

no Moo;

1;

