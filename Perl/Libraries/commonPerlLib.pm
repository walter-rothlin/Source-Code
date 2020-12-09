
# $Header: /app/TIT/data/repositories/FT/plain_daily_production/interfaces/GMM/common/commonPerlLib.pm,v 1.2 2009/04/29 16:55:02 msrivino Exp $

# @(#)commonPerlLib.pm	1.2 08/23/07 20:39:03 /app/ft/build/tools/cgi/common/SCCS/s.commonPerlLib.pm

#
# START---------------------------------------------------------------------
# Author:        Dmitriy Volfson 
# Description:   Contains a lot of generic Perl-functions
#
#
# External modules used: DBI, CGI
# In House modules used: littlePerlLib.pm 
#  
# History:
# 03/12/2001  V1.0  Dmitriy Volfson  Initial Version 
# 05/02/2001  V1.1  Dmitriy Volfson  added removeLineFromFile 
# 05/03/2001  V1.2  Dmitriy Volfson  added insertLineInFile 
# 05/09/2001  V1.3  Dmitriy Volfson  added getAverageValueFromArray
#                                    added combineFltFiles  
# 05/15/01    V1.4  Dmitriy Volfson  modified  combineFltFiles
# 02/13/02    V1.5  Dmitriy Volfson  added chompFile
# END-----------------------------------------------------------------------
#

use  littlePerlLib;
#external modules
use CGI qw( :standard );
use DBI;


use vars qw/@ISA @EXPORT $error/;
require Exporter;
@ISA = 'Exporter';

# let's break all function by categories
@DBIRELATED = qw ( sqlToFlatWithCallBack_dbh);
@HTML = qw (getHtmlSelectFromHash);
@CGI  = qw (
           displayCgiParameters
           displayCgiParametersAsHiddenFields 
           sendCookie 
           redirectFunctionOutput
       ); 

@FOR_FLAT_FILES = qw (fltRecordExists combineFltFiles);

@FILES_AND_DIR = qw (getDirFileNames insertLineInFile removeLineFromFile chompFile);

@FOR_ARRAYS = qw ( getAverageValueFromArray );


@EXPORT = (@DBIRELATED,@HTML,@CGI,@FOR_FLAT_FILES,@FILES_AND_DIR, @FOR_ARRAYS );


####################################################################################
# Functions for building html Componenets
#####################################################################################
# this function will build html select out of hash
# hash keys will become values
# hash values will become display strings
sub getHtmlSelectFromHash {
  my($size,$widgetName,$selectedStr,$aHashRef) = @_;
 
  my (%ahash) = %$aHashRef;
 
  my($retVal) = "";
  my ($option) = "";
 
  my($aField)   = "";
  if (length($size)        == 0) {$size        = "1"; }
  if (length($widgetName)  == 0) {$widgetName  = ""; }
  if (length($selectedStr) == 0) {$selectedStr = ""; }
 
  $retVal = sprintf ("<SELECT NAME=\"%s\" size=\"%s\">\n",$widgetName,$size);
  foreach $aField (keys %ahash) {
 
     $option = $ahash{$aField};
 
     if ($selectedStr eq $aField) {
         $retVal = sprintf ("%s   <OPTION VALUE=\"%s\" SELECTED>%s\n",$retVal,$aField,$option);
     } else {
         $retVal = sprintf ("%s   <OPTION VALUE=\"%s\">%s\n",$retVal,$aField,$option);
     }
}
  $retVal = sprintf ("%s</SELECT>\n",$retVal);
  return $retVal;
 
}

########################
# cgi
########################
sub displayCgiParameters {
   my($query) = new CGI;
   my(@names) = $query->param;

   print "displayCgiParameters \n <br> \n";
   foreach $aName (@names) {
     my($aValue) = param($aName);
     printf ("%s=%s<br> \n", $aName,$aValue);
   }
} 

sub displayCgiParametersAsHiddenFields {
  
  my($query) = new CGI;

  print ("<!-- displayCgiParametersAsHiddenFields --><br> \n ");
  my(@names) = $query->param;
  foreach $aName (@names) {
    my($aValue) = param($aName);
    printf ("<INPUT TYPE=HIDDEN NAME=\"%s\" VALUE=\"%s\"> <br> \n", $aName,$aValue);
  }

} 




sub sendCookie {
   my ($cookname,$cookValue, $expires ) = @_;
 
 
 
   my $cookie = cookie (
                -NAME  => $cookname,
                -VALUE => $cookValue,
                -EXPIRES =>  $expires
        );
 
 
 
   print header(-COOKIE => $cookie);
 
}

########################
##  DBI
########################
sub dbConnect {
  my ($db,$login,$password,$LogFile,$verbal,$autoCommit,$printError) = @_;
  $verbal     = setDefault($verbal,$FALSE);
  $autoCommit = setDefault($autoCommit,$FALSE);
  $printError  = setDefault($printError,$TRUE);
 
  # remove @ at the beginning of the dB Name because of TNS
  $db =~ s/^\@//g;
  addToLogFile ("Connecting to dB:${db}:",  $LogFile, $verbal);
  my $dbh = DBI->connect(
                         "dbi:Oracle:${db}",
                         "${login}",
                         "${password}",
                         {
                           PrintError => $printError,
                           RaiseError => $FALSE,
                           AutoCommit => $autoCommit
                         }
                 ) || addToLogFile("Database connection not made: $DBI::errstr", $LogFile, $TRUE, $ERROR);
   return $dbh;
}
 
sub dbDisconnect {
   my ($dbh) = @_;
   $dbh->disconnect();
}

#################
## sql to flat
#################

sub sqlToFlatWithCallBack_dbh {
  my ($sttmnt,$tmpOutFile,$dbh,$replaceCharForNewLine,$callBackFunction) = @_;
  my $produceFile;
  my $useCallBack;
  my $recordHashRef = ();

  if ($tmpOutFile ne "") {
     $produceFile = $TRUE;
  }

  if ($callBackFunction ne "") {
    $useCallBack = $TRUE;
  }
  
  $countOfSqlToFlat = 0;
  $replaceCharForNewLine = setDefault($replaceCharForNewLine," ");
 
  my ($sql) = qq {$sttmnt};
 
  my $sth = $dbh->prepare($sql);
 
  $sth->execute();

  #short version if we do not want tp write to file
  if ($useCallBack eq $TRUE && $produceFile eq $FALSE) { 
    $recordHashRef = $sth->fetchrow_hashref;

   while ($recordHashRef ne "") {
    &$callBackFunction($recordHashRef);
    $recordHashRef = $sth->fetchrow_hashref;
   }
  }

  if($produceFile) {
    open(TMP_OUT_FILE,"> $tmpOutFile") || return "Can't open temp file $tmpOutFile: $!\n";
    my $rl_names = $sth->{NAME};
    my $line = "";
    foreach $field_name (@$rl_names) {
          $line = "${line}|${field_name}"
    }
    $line =~ s/^\|//;
    print TMP_OUT_FILE "$line\n";
    while (@results = $sth->fetchrow) {
      if ($DBI::err) {
        print "$DBI::errstr\n";
        last;
       }
      my $line = "";
      foreach $field_name (@$rl_names) {
         $value = shift @results;
         $recordHashRef->{"$field_name"} = "$value";
         $line = "${line}|" . $value;
      }
       if ($useCallBack eq $TRUE) {
          &$callBackFunction($recordHashRef);
       }
      $line =~ s/^\|//;
      if ($replaceCharForNewLine eq "<BR>") {
         $line =~ s/\n/\<BR\>/g;
      } else {
         $line =~ s/\n/ /g;
      }
      $line =~ s/\r//g;
      print TMP_OUT_FILE "$line\n";
      $countOfSqlToFlat++;
    }
 
    $sth->finish();
   close TMP_OUT_FILE;
 }
}




####
# Files 
######

sub redirectFunctionOutput {
  my ($functioReference, $argsRef) = @_;

  my ($pid) =  `echo $$  2>&1` ;  chop $pid; 
  my ($outFile) = "/tmp/redirectFunctOutput_${pid}.tmp";

  open(FILE, ">$outFile")
    or die "couldn't open $outFile for writing: $!\n";

  my($oldHandle) = select(FILE);

 
  $functioReference->(@$argsRef);

  select($oldHandle);

  close(FILE);

  my $output = `cat  $outFile`;

  unlink($outFile);


  return  $output;
}


#####################################################
## functions for  flat files more in littlePerlLib.pm 
#####################################################

sub fltRecordExists {
  my ($fileName,$sepChar,$locWhereClause) = @_;
  my @records=  getColumnValues ($fileName,$sepChar,"",$locWhereClause);
  my $count = @records;
  
  return $count ; 
}
# combineFltFiles
#
#
# Description:
# ------------
# Combine one column($valueFieldName) from each file based on key column ($keyFieldName) 
# 
#
# e.g.
# file1 column A, B, C
# file2 column A, B, E
# file3 column A, B, G, F, H
## 
## Setting
## $keyFieldName   = "A"; 
## $valueFieldName = "B" 
## $displaySpecialColumns = $TRUE; 
## 
# will result in
# outFile columns:  A B_1 B_2 B_3 MIN MAX AVERAGE LAST 
#
# if you do not want too get min max columns set $displaySpecialColumns to $FALSE


sub combineFltFiles {
  my ($outFileName, $fileRef, $keyFieldName, $valueFieldName, $sepChar, $displaySpecialColumns,
      $specificKeykeyFieldValuesRef) = @_;
 
  open(OUT, "> $outFileName") || die "Can't open $outFileName: $!\n";
  $sepChar =  setDefault ($sepChar,"\\|");
 
  my $min, $max , $average, $last = 0;
  $displaySpecialColumns =  setDefault($silent,$TRUE);
  my (@specilaColumns) = ("MIN", "MAX", "AVERAGE", "LAST");
 
  my @files = @$fileRef;
  my $i = 0;
  my @keyVlaues = ();
 
  my @transTables = ();
 
  foreach $file (@files) {
    my $name = "hashT${i}";
    %$name =  getTransTable ($file, $sepChar, $whereClause,$keyFieldName,$valueFieldName,$keyFieldFormat,$valueFieldFormat);
    my(@keyData) = getColumnValues($file,$sepChar,"${keyFieldName}","","",$TRUE);
 
    @transTables = (@transTables, \%$name);
    $i++;
    #@keyVlaues = (@keyVlaues , keys  %$name );
    @keyVlaues = (@keyVlaues , @keyData );
  }
 
  #distinct values
  %seen = ();
  #displayArray(@keyVlaues);
 
  if ($specificKeykeyFieldValuesRef ne "") {
    my @specificKeykeyFieldValues = @$specificKeykeyFieldValuesRef;
    if ($#specificKeykeyFieldValues != -1 ) {
      @keyVlaues = @$specificKeykeyFieldValuesRef;
    }
  }
  
  @keyVlaues = grep { ! $seen{$_} ++ } @keyVlaues;
 
  $i = 1;
  print OUT "${keyFieldName}|";
  foreach $file (@files) {
    print OUT "${valueFieldName}_${i}|";
    $i++;
  }
  if($displaySpecialColumns eq $TRUE) {
    foreach $spColumn (@specilaColumns ) {
     print OUT  "$spColumn|";
    }
  }
print OUT "\n";
 
  foreach $keyVal (@keyVlaues ) {
    print OUT "${keyVal}|";
    my @values = ();
    foreach $hashV (@transTables) {
 
       $value = $hashV->{$keyVal};
       @values = (@values, $value);
       print OUT "${value}|";
   }
 
   if($displaySpecialColumns eq $TRUE) {
     $max = getMaxValFromArray (@values);
     $min = getMinValFromArray (@values);
     $average =  getAverageValueFromArray (\@values, $TRUE);
     $last = $values[$#values];
     print OUT "$min|$max|$average|$last|";
     }
   print OUT  "\n";
  }
 
  close(OUT);
}

############################
### Files and dirs
#############################
sub getDirFileNames {
  my ($dirName, $displayFullName, $pattern) = @_;
  opendir (DIR, $dirName);
 
  while (defined ($file = readdir DIR)) {
 
   next if $file=~ /^\.\.?$/; # skip . and ..
   if ($pattern ne "" ) {
    if ($file =~ $pattern ) {
    } else {
     next;
    } 
   }
   if ($displayFullName eq $TRUE) {
    $file = "$dirName/$file";
   }
   @files = (@files ,$file ); 
  }
  closedir(DIR);
 
  return @files;
}

sub removeLineFromFile {
  my ($fileName, $lineToRemove, $outFileName) = @_;
  $outFileName = setDefault($outFileName,$fileName);
  my(@Lines) = readFile($fileName);
  my $lineNo = 1;
 
  open (OUT, "> $outFileName") || print "Can't open output file $outFileName: $!\n";;
 
  foreach $line (@Lines) {
 
   if ($lineNo eq  $lineToRemove) {
    $removedLine = $line;
   } else {
     print (OUT  "$line\n");
    }
   $lineNo++;
  }
 
  close(OUT);
  return  $removedLine ;
}

sub insertLineInFile {
  my ($fileName, $lineToInsert, $position, $outFileName) = @_;
  $outFileName = setDefault($outFileName,$fileName);
  my(@Lines) = readFile($fileName);
  my $lineNo = 1;
 
  my $NumberOflines = @Lines;
 
  open (OUT, "> $outFileName") || print "Can't open output file $outFileName: $!\n";;
 
  if ($position > $NumberOflines) {
    $linesToProcess= $position;
  } else {
   $linesToProcess = $NumberOflines ;
  }
 
  for ($i = 0; $i < $linesToProcess; $i++) {
    if (($i + 1) ==  $position) {
     print (OUT  "$lineToInsert\n");
    }
 
   $line = $Lines[$i];
 
   if ($position > $NumberOflines &&( $i + 1) == $linesToProcess) {
 
   } else {
     print (OUT  "$line\n");
   }
 
  }
  close(OUT);
  return 1;
}


sub chompFile {
   my($infileName,$outfileName) = @_;
 
   open(IN, $infileName) || showError("Error (: Can't op en infile:${infileName}: $!");
   open(OUT, ">$outfileName") || showError("Error  Can't open oufile:${outfileName}: $!");

   while (defined ($aLine = <IN>)) {
     chomp($aLine);
     $aLine =~ s///g;
 
     print(OUT "${aLine}\n");
   }
   close(OUT);
   close(IN);
}


################################
### functions dealing with arrays
#################################
sub getAverageValueFromArray {
  my($inArrayRef, $asInteger)  = @_;
  my (@inArray) = @$inArrayRef;
  my $value = "";
  my $sum = 0;
  my $i = 0;
 
  foreach $value (@inArray) {
   $sum = $sum + $value;
   $i++;
  }
 
  my $average = $sum/$i;
 
  if ($asInteger eq $TRUE) {
     $average  = sprintf("%d",$average  );
  }
 
  return $average;
}

# function to prodece files for BarChart java applet

sub produceBarChartAppletDataFileFromFltFile {
  my ($inFileName,$outFileName,$fieldsColumnName, $indexColumnsRef, $indexColorsHashRef) = @_;
  my (@indexColumns) = @$indexColumnsRef;
  my %valuesHash = ();
  my @fields = ();
 
  ($header,$RefAll,$sepChar, $locNameToIndexRef) = getAllMatchesFromFltFile($inFileName,"\\|","","","","");
  @records = derefAref( $RefAll);
  %locNameToIndex = derefHref($locNameToIndexRef);
 
 
  foreach $record (  @records) {
    @parts = split($sepChar,$record);
    @fields = (@fields, ($parts[$fieldsColumnName]));
 
    foreach $indexColumn (@indexColumns) {
      $value = ($parts[$locNameToIndex{$indexColumn}]);
      if ($valuesHash {$indexColumn} ne "") {
        $valuesHash{$indexColumn} = $valuesHash{$indexColumn} . "," . $value;
      } else {
          $valuesHash{$indexColumn}= $value;
      }
    }
 
  }
 
 
  produceBarChartAppletDataFile ($outFileName,\@fields,$indexColumnsRef, $indexColorsHashRef, \%valuesHash)
 
}
sub produceBarChartAppletDataFile {
  my ($outFileName, $fieldNamesRef, $indexNamesRef, $indexColorsHashRef, $valueHashRef, $addSeparator) = @_;

 
  my %indexColors = %$indexColorsHashRef;
  my @fieldNames = @$fieldNamesRef;
  my $numberOfFields = @fieldNames;
  my @indexNames = @$indexNamesRef;
  my $numberOfIndexes = @indexNames ;
  $outFileName = $outFileName || "bars.data";
  my %valuesHash = %$valueHashRef;

  my @defaultIndexColors = ("255, 0, 0", "0, 0, 255",  "0,255,0", "204,0,204");


 
  $addSeparator = setDefault($addSeparator,$TRUE);
 
  open(OUT, "> $outFileName") || die "Can't open $outFileName: $!\n";
  print OUT "# begin of file\n\n# number of fields\n";
 
  if ($addSeparator eq $TRUE) {
    $numberOfIndexes = $numberOfIndexes + 1;
  }
  print OUT "$numberOfFields\n";
 
  print OUT "# fields\n";
 
  foreach $field (@fieldNames) {
    print OUT "$field\n";
  }
 
  print OUT "# number of indexes\n$numberOfIndexes\n";
 
  for ($i=0; $i<= $#indexNames;$i++) {
   print OUT "# the name of the index $i\n";
   $indexName = $indexNames[$i];
   print OUT "$indexName\n";
 
   print OUT "# color of the index $indexName \n";
   my $indexColor = $indexColors{$indexName};
   if ($indexColor eq "") {
     $indexColor = $defaultIndexColors [$i];
   }
   print OUT "$indexColor\n";
 
   print OUT "# the values for all fields of the index $indexName \n";
   $valuesStr = $valuesHash {$indexName};
   print OUT "$valuesStr\n";
 
  }
  if ($addSeparator eq $TRUE) {
    print OUT "# just separator\n";
    print OUT "SEPARATOR\n";
     print OUT "0,0,0\n";
    foreach  $field (@fieldNames) {
      print OUT "0,";
    }
  }
   close (OUT);
 
 
}



#################
return 1;
