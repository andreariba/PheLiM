#!/usr/bin/perl
use strict;
use warnings;

if(@ARGV != 2) {
    die "usage: cluster.pl siRNA-seq-file hcprog\n";
}

my ($filename, $hcprog) = @ARGV;
my $hcdist = 4; #set the max hamming distance for clustering seed sequences
my $clustersfilename = "temp_clusters.txt"; #name of the file where clusters of seed clusters will be saved

#fasta file of seed sequence clusters
my $fastafilename = $filename."-fastajoined";

#file with mappings from clusterID to siRNAIDs
my $codefilename = $filename."-fastacode";

my $name = "";
my $seq = "";
my %siseq = ();

open(F, "$filename") || die "cannot open $filename\n";
while (<F>) {
    my $row = $_;
    chomp($row);
    if( $row =~ /^>(.*)/ ) {
	$name = $1;
    } else {
	$seq = substr $row, 1, 7;
	push @{$siseq{$seq}}, $name;
    }
}
close(F);

open(OF, ">$fastafilename") || die "cannot open $fastafilename\n";
open(CF, ">$codefilename") || die "cannot open $codefilename\n";
my $clusternr = 0;
foreach my $seedseq (keys(%siseq)) {
    $clusternr++;
    print OF ">cluster-$clusternr\n$seedseq\n";
    print CF "cluster-$clusternr\t", join("|", @{$siseq{$seedseq}}), "\n";
}
close(OF);
close(CF);

system("$hcprog -hamming $hcdist $fastafilename $clustersfilename");

if (!(-e $clustersfilename) || (-z $clustersfilename)) {
    die "Clusters of seed sequence clusters have not been computed\n";
}

open(FF, $codefilename) || die "cannot open $codefilename\n";
my %clusters = ();
while(<FF>) {
    chomp($_);
    my @s = split(/\t/, $_);
    push @{$clusters{$s[0]}}, split(/\|/, $s[1]);
}
close(FF);

open(FF, $clustersfilename) || die "cannot open $clustersfilename\n";
while(<FF>) {
    chomp($_);
    $_ =~ s/\s+$//g;
    my @c = split(/\|/, $_);
    my %alls = ();
    foreach my $cluster (@c) {
	foreach my $si (@{$clusters{$cluster}}) {
	    $alls{$si} = 1;
	}
    }
    print "|", join("|", keys(%alls)), "|", "\n";
}
close(FF);
