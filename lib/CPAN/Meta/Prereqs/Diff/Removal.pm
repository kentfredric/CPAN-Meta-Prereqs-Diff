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

sub is_addition { }
sub is_removal  { 1 }
sub is_change   { }

sub describe {
  return sprintf q[%s.%s: -%s %s], $_[0]->phase, $_[0]->type, $_[0]->module, $_[0]->requirement;
}

no Moo;

1;

