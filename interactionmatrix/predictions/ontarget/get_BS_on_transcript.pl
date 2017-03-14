#BS on transcripts

use strict;
use warnings;

sub match_positions {
    my ($regex, $string) = @_;
    return if not $string =~ /$regex/;
    return ($-[0], $+[0]);
}

sub match_all_positions {
    my ($regex, $string) = @_;
    my @ret;
    while ($string =~ /$regex/g) {
        push @ret, [ $-[0], $+[0] ];
    }
    return @ret
}

sub revrnacomp {
	my ($dna) = @_;
	my $revcomp = reverse($dna);
	$revcomp =~ tr/ACGUacgu/UGCAugca/;
	return $revcomp;
}


my $targetfilename = $ARGV[0];
my $sirnafilename = $ARGV[1];
my $outfile = "outontargetsites.tab";
my $fhtarget;
my $fhsirna;
my $fhout;


print "Input transcripts: $targetfilename\n";
open($fhtarget, '<', $targetfilename) or die "Could not open file '$targetfilename' $!";
print "Input siRNAs: $sirnafilename\n";
open($fhsirna, '<', $sirnafilename) or die "Could not open file '$sirnafilename' $!";

print "Output file: $outfile\n";
open($fhout, '>', $outfile) or die "Could not open file '$outfile' $!";


my @splittedrow = {"","",0,0};

my %hash = ();

my $name = "";
my $seq = "";

#open($fhout, '>', $) or die "Could not open file '$' $!";

while (my $row = <$fhtarget>) {
	chomp($row);
	if( $row =~ /^>(.*)/ ) {
		if($seq ne "") {
			$seq =~ tr/T/U/;
			$hash{ $name } = $seq;
			#print $name."\t".length($seq)."\t".$seq."\n";
		}
		$name = $1;
		$seq="";
	} else {
		$seq = $seq.$row;
	}
	#while ( my ($key, $value) = each(%hash) ) {
	#        print "$key => $value\n";
	#}
}

#while ( my ($key, $value) = each(%hashwout) ) {
#	$i++;
#        print "$i: $key => $value\n";
#}
#$i=0;

#while ( my ($key, $value) = each(%hashwith) ) {
#	$i++;
#        print "$i: $key => $value\n";
#}
#$i=0;

my $start=0;
my $end=0;

while (my $row = <$fhsirna>) {
	chomp($row);
	if( $row =~ /^>(.*)/ ) {
		$name = $1;
	} else {
		$seq = revrnacomp(substr($row,0,19));
		$seq =~ tr/T/U/;
		#print $name."\t".$seq."\n";
		while ( my ($key, $value) = each(%hash) ) {
			($start,$end) = match_positions($seq,$value);			
				#print $fhout $splittedrow[0]."\t".$splittedrow[1]."\t".$splittedrow[4]."\t".$splittedrow[3]."\t$start\t$end\n";
			
			#print "Fold: $fold\n";
			if( defined($start) && defined($end) ) {
				#print "$name\t$seq\t$start-$end\t".substr($value,$start,$end-$start)."\n";
				my $dna = $row;
				my $reversed = revrnacomp($dna);
				open(my $tempfh, '>', "sequence.txt") or die "Could not open file 'sequence.txt' $!";
				print $tempfh "$dna\n$reversed\n";
				close $tempfh;
				my $cmd = "RNAduplex < sequence.txt | awk \'{print \$NF;}\' | sed \'s/[()]//g\'"; #
				my $out = qx($cmd);
				chomp($out);
				#print "$dna\t$reversed\t$out\n";
				#my @out = split(/:/,$out);
				my $hybrid= $out;
				#print "Energy: $hybrid\n";
				open($tempfh, '>', "sequence.fa") or die "Could not open file 'sequence.fa' $!";
				print $tempfh ">seq\n$dna\n";
				close $tempfh;
				my @cmd = ("RNAfold --noPS < sequence.fa > tempfold.txt\n");
				system(@cmd);
				@cmd = ("awk \'{printf \$0;getline;getline;print \"\t\"\$NF;}\' tempfold.txt > t.tab");
				system(@cmd);
				@cmd = ("sed -i \'s/>//g\' t.tab");
				system(@cmd);
				@cmd = ("sed -i \'s/)//g\' t.tab");
				system(@cmd);
				@cmd = ("sed -i \'s/(//g\' t.tab");
				system(@cmd);
				@cmd = ("mv t.tab tempfold.txt");
				system(@cmd);
				open(my $fhacc, '<', "tempfold.txt") or die("Unable to open file tempfold.txt: $!\n");
				my $in = <$fhacc>;
				chomp($in);
				my @out = split(/\t/,$in);
				my $fold = $out[1];
				close($fhacc);
				@cmd = ("echo $value | RNAplfold -W 80 -L 40 -u 17");
				system(@cmd);

				if( -e "plfold_lunp" ) {
					open my $fhacc, '<', "plfold_lunp" or die("Unable to open file plfold_lunp: $!\n");
					my $num_lines = $end+1;
					while(my $line = <$fhacc>) {
						if($num_lines==0) {
							#print $line;
							my @splitted = split(/\t/,$line);
							print $fhout "$name\t$key\t$row\t$fold\t$hybrid\t".$splitted[8]."\t".$splitted[16]."\n";
							print "$name\t$key\t$row\t$fold\t$hybrid\t".$splitted[8]."\t".$splitted[16]."\n";
   						}
						$num_lines--;
					}
					close($fhacc);
					unlink("plfold_lunp");
					unlink("plfold_dp.ps");
				} else {
					die("ERROR: RNAplfold!");
				} 
			}
		}
	}
	
}

for (keys %hash) {
	delete $hash{$_};
}

close($fhtarget);
close($fhsirna);
close($fhout);
