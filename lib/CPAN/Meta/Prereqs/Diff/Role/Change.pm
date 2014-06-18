use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package CPAN::Meta::Prereqs::Diff::Role::Change;

our $VERSION = '0.001000';

# ABSTRACT: A base behavior for prerequisite changes

# AUTHORITY

use Moo::Role qw( has requires );

has 'phase'  => ( is => ro =>, required => 1, );
has 'type'   => ( is => ro =>, required => 1, );
has 'module' => ( is => ro =>, required => 1, );

requires is_addition =>;
requires is_removal  =>;
requires is_change   =>;
requires describe    =>;

no Moo;

1;

