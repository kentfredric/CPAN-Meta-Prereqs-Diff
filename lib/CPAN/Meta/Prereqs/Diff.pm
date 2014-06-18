use strict;
use warnings;

package CPAN::Meta::Prereqs::Diff;

# ABSTRACT: Compare dependencies between releases using CPAN Meta.

use Moo 1.000008 qw( has );
use List::MoreUtils qw( uniq );
use Scalar::Util qw( blessed );
use CPAN::Meta::Prereqs::Diff::Addition;
use CPAN::Meta::Prereqs::Diff::Removal;
use CPAN::Meta::Prereqs::Diff::Change;
use CPAN::Meta::Prereqs::Diff::Upgrade;
use CPAN::Meta::Prereqs::Diff::Downgrade;

has 'new_prereqs' => ( is => ro =>, required => 1 );
has 'old_prereqs' => ( is => ro =>, required => 1 );

has '_real_old_prereqs' => (
  is      => ro  =>,
  lazy    => 1,
  builder => sub { return $_[0]->_get_prereqs( $_[0]->old_prereqs ) }
);
has '_real_new_prereqs' => (
  is      => ro  =>,
  lazy    => 1,
  builder => sub { return $_[0]->_get_prereqs( $_[0]->new_prereqs ) }
);

sub _dep_add {
  my ( $self, $phase, $type, $module, $requirement ) = @_;
  return CPAN::Meta::Prereqs::Diff::Addition->new(
    phase       => $phase,
    type        => $type,
    module      => $module,
    requirement => $requirement,
  );
}

sub _dep_remove {
  my ( $self, $phase, $type, $module, $requirement ) = @_;
  return CPAN::Meta::Prereqs::Diff::Removal->new(
    phase       => $phase,
    type        => $type,
    module      => $module,
    requirement => $requirement,
  );
}

sub _dep_change {
  my ( $self, $phase, $type, $module, $old_requirement, $new_requirement ) = @_;
  if ( $old_requirement =~ /[<>=, ]/ or $new_requirement =~ /[<>=, ]/ ) {
    return CPAN::Meta::Prereqs::Diff::Change->new(
      phase           => $phase,
      type            => $type,
      module          => $module,
      old_requirement => $old_requirement,
      new_requirement => $new_requirement,
    );
  }
  require version;
  if ( version->parse($old_requirement) > version->parse($new_requirement) ) {
    return CPAN::Meta::Prereqs::Diff::Downgrade->new(
      phase           => $phase,
      type            => $type,
      module          => $module,
      old_requirement => $old_requirement,
      new_requirement => $new_requirement,
    );
  }
  if ( version->parse($old_requirement) < version->parse($new_requirement) ) {
    return CPAN::Meta::Prereqs::Diff::Upgrade->new(
      phase           => $phase,
      type            => $type,
      module          => $module,
      old_requirement => $old_requirement,
      new_requirement => $new_requirement,
    );
  }
  return;
}

sub _get_prereqs {
  my ( $self, $input_prereqs ) = @_;
  if ( ref $input_prereqs and blessed $input_prereqs ) {
    return $input_prereqs if $input_prereqs->isa('CPAN::Meta::Prereqs');
    return $input_prereqs->effective_prereqs if $input_prereqs->isa('CPAN::Meta');
  }
  if ( ref $input_prereqs and 'HASH' eq ref $input_prereqs ) {
    require CPAN::Meta::Prereqs;
    return CPAN::Meta::Prereqs->new($input_prereqs);
  }
  require Carp;
  Carp::croak(q[ prereqs parameters take either CPAN::Meta::Prereqs, CPAN::Meta, or a valid CPAN::Meta::Prereqs hash structure]);
}

sub _phase_rel_diff {
  my ( $self, $phase, $type ) = @_;

  my %old_modules = %{ $self->_real_old_prereqs->requirements_for( $phase, $type )->as_string_hash };
  my %new_modules = %{ $self->_real_new_prereqs->requirements_for( $phase, $type )->as_string_hash };

  my @all_modules = do {
    my %all_modules = map { $_ => 1 } keys %old_modules, keys %new_modules;
    sort { $a cmp $b } keys %all_modules;
  };

  my @out_diff;

  for my $module (@all_modules) {
    if ( exists $old_modules{$module} and exists $new_modules{$module} ) {

      # no change
      next if $old_modules{$module} eq $new_modules{$module};

      # change
      push @out_diff, $self->_dep_change( $phase, $type, $module, $old_modules{$module}, $new_modules{$module} );
      next;
    }
    if ( exists $old_modules{$module} and not exists $new_modules{$module} ) {

      # remove
      push @out_diff, $self->_dep_remove( $phase, $type, $module, $old_modules{$module} );
      next;
    }

    # add
    push @out_diff, $self->_dep_add( $phase, $type, $module, $new_modules{$module} );
    next;

  }
  return @out_diff;
}

sub diff {
  my ( $self, %options ) = @_;
  my @phases = @{ exists $options{phases} ? $options{phases} : [qw( configure build runtime test )] };
  my @types  = @{ exists $options{types}  ? $options{types}  : [qw( requires recommends suggests conflicts )] };

  my @out_diff;

  for my $phase (@phases) {
    for my $type (@types) {
      push @out_diff, $self->_phase_rel_diff( $phase, $type );
    }
  }
  return @out_diff;

}

no Moo;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

CPAN::Meta::Prereqs::Diff - Compare dependencies between releases using CPAN Meta.

=head1 VERSION

version 0.000000

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
