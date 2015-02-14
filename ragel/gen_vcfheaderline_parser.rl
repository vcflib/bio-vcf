# Ragel lexer for VCF-header
#
# This is compact a parser/lexer for the VCF header format. Bio-vcf
# uses the parser to generate meta information that can be output to
# (for example) JSON format. The advantage of using ragel as a state
# engine is that it allows for easy parsing of key-value pairs with
# syntax checking and, for example, escaped quotes in quoted string
# values. This ragel parser/lexer generates valid Ruby; it should be
# fairly trivial to generate python/C/JAVA instead. Note that this
# edition validates ID and Number fields only.  Other fields are
# dumped 'AS IS'.
#
# Note the .rb version is generated from ./ragel/gen_vcfheaderline_parser.rl
#
# by Pjotr Prins (c) 2014/2015

module BioVcf

  module VcfHeaderParser

    module RagelKeyValues

      def self.debug msg
        # nothing
	# $stderr.print "DEBUG: ",msg,"\n"
      end
      
=begin
%%{

  machine simple_lexer;
  
  action mark { ts=p }
  action endquoted {
    emit.call(:value,data,ts,p)
  }

  action kw {
    emit.call(:kw,data,ts,p)
  }
  
  squote = "'";
  dquote = '"';
  not_squote_or_escape = [^'\\];
  not_dquote_or_escape = [^"\\];
  escaped_something = /\\./;
  ss = squote ( not_squote_or_escape | escaped_something )* >mark %endquoted squote;
  dd = dquote ( not_dquote_or_escape | escaped_something )* >mark %endquoted dquote;

  integer     = ('+'|'-')?digit+;
  float       = ('+'|'-')?digit+'.'digit+;
  assignment  = '=';
  identifier  = ( alnum (alnum|'.'|'_')* ); 
  version     = ( digit (alnum|'.'|'_'|'-')* ); 
  str         = (ss|dd)* ;
  boolean     = '.';
  date        = str;
  key_word    = ( ('Type'|'Description'|'Source'|identifier - ('ID'|'Number'|'length'|'Version'|'assembly'|'Date'|'CommandLineOptions')) >mark %{ emit.call(:key_word,data,ts,p) } );
  any_value   = ( str|( integer|float|boolean|identifier >mark %{ emit.call(:value,data,ts,p) } ));
  id_value   = ( identifier >mark %{ emit.call(:value,data,ts,p) } );

  version_value  = ( str| ( version >mark %{ emit.call(:value,data,ts,p) } ));
  date_value  = ( date );
  gatk_value  = ( str );
  number_value = ( ( integer|boolean|'A'|'R'|'G' ) >mark %{ emit.call(:value,data,ts,p) } );

  id_kv     = ( ( ('ID'|'assembly') %kw '=' id_value ) %{ debug("ID FOUND") } @!{ error_code="Malformed ID"} );
  version_kv = ( ( ('Version') %kw '=' version_value ) @!{ error_code="Version"} );
  number_kv = ( ( ('Number'|'length') %kw '=' number_value ) @!{ error_code="Number"} );
  date_kv =  ( ( ('Date') %kw '=' date_value ) %{ debug("DATE FOUND") } @!{ error_code="Date"} );
  gatk_kv =  ( ( ('CommandLineOptions') %kw '=' gatk_value ) @!{ error_code="GATK"} );
  key_value = ( id_kv | version_kv | date_kv | number_kv | gatk_kv | (key_word '=' any_value) ) %{ debug("KEY_VALUE found") } >mark @!{ error_code="unknown key-value " };

  main := ( '##' ('FILTER'|'FORMAT'|'contig'|'INFO'|'ALT'|'GATKCommandLine') '=') (('<'|',') key_value )* '>';
}%%
=end

%% write data;
# %% this just fixes syntax highlighting...

def self.run_lexer(buf, options = {})
  do_debug = (options[:debug] == true)
  $stderr.print "---> ",buf,"\n" if do_debug
  data = buf.unpack("c*") if(buf.is_a?(String))
  eof = data.length
  values = []
  stack = []

  emit = lambda { |type, data, ts, p|
    # Print the type and text of the last read token
    # p ts,p
    $stderr.print "EMITTED: #{type}: #{data[ts...p].pack('c*')}\n" if do_debug
    values << [type,data[ts...p].pack('c*')]
  }

  error_code = nil
  
  %% write init;
  %% write exec;

  raise "ERROR: "+error_code+" in "+buf if error_code

  begin
    res = {}
    # p values
    values.each_slice(2) do | a,b |
      $stderr.print '*',a,b if do_debug
      keyword = a[1]
      value = b[1]
      value = value.to_i if ['length','Epoch'].index(keyword)
      res[keyword] = value
      # p h[:value] if h[:name]==:identifier or h[:name]==:value or h[:name]==:string
    end
  rescue
    print "ERROR: "
    p values
    raise
  end
  $stderr.print(res,"\n") if do_debug
  res
end
    end
  end 
end

if __FILE__ == $0

gatkcommandline = <<LINE1
##GATKCommandLine=<ID=CombineVariants,Version=3.2-2-gec30cee,Date="Thu Oct 30 13:41:59 CET 2014",Epoch=1414672919266,CommandLineOptions="analysis_type=CombineVariants input_file=[] showFullBamList=false read_buffer_size=null phone_home=AWS gatk_key=null tag=NA read_filter=[] intervals=null excludeIntervals=null interval_set_rule=UNION interval_merging=ALL interval_padding=0 reference_sequence=/hpc/cog_bioinf/GENOMES/Homo_sapiens.GRCh37.GATK.illumina/Homo_sapiens.GRCh37.GATK.illumina.fasta nonDeterministicRandomSeed=false disableDithering=false maxRuntime=-1 maxRuntimeUnits=MINUTES downsampling_type=BY_SAMPLE downsample_to_fraction=null downsample_to_coverage=1000 baq=OFF baqGapOpenPenalty=40.0 refactor_NDN_cigar_string=false fix_misencoded_quality_scores=false allow_potentially_misencoded_quality_scores=false useOriginalQualities=false defaultBaseQualities=-1 performanceLog=null BQSR=null quantize_quals=0 disable_indel_quals=false emit_original_quals=false preserve_qscores_less_than=6 globalQScorePrior=-1.0 validation_strictness=SILENT remove_program_records=false keep_program_records=false sample_rename_mapping_file=null unsafe=null disable_auto_index_creation_and_locking_when_reading_rods=false num_threads=1 num_cpu_threads_per_data_thread=1 num_io_threads=0 monitorThreadEfficiency=false num_bam_file_handles=null read_group_black_list=null pedigree=[] pedigreeString=[] pedigreeValidationType=STRICT allow_intervals_with_unindexed_bam=false generateShadowBCF=false variant_index_type=DYNAMIC_SEEK variant_index_parameter=-1 logging_level=INFO log_to_file=null help=false version=false variant=[(RodBindingCollection [(RodBinding name=variant source=/hpc/cog_bioinf/data/robert/testIAP/testSubsetExome/tmp/testSubsetExome.filtered_snps.vcf)]), (RodBindingCollection [(RodBinding name=variant2 source=/hpc/cog_bioinf/data/robert/testIAP/testSubsetExome/tmp/testSubsetExome.filtered_indels.vcf)])] out=org.broadinstitute.gatk.engine.io.stubs.VariantContextWriterStub no_cmdline_in_header=org.broadinstitute.gatk.engine.io.stubs.VariantContextWriterStub sites_only=org.broadinstitute.gatk.engine.io.stubs.VariantContextWriterStub bcf=org.broadinstitute.gatk.engine.io.stubs.VariantContextWriterStub genotypemergeoption=UNSORTED filteredrecordsmergetype=KEEP_IF_ANY_UNFILTERED multipleallelesmergetype=BY_TYPE rod_priority_list=null printComplexMerges=false filteredAreUncalled=false minimalVCF=false excludeNonVariants=false setKey=set assumeIdenticalSamples=false minimumN=1 suppressCommandLineHeader=false mergeInfoWithMaxAC=false filter_reads_with_N_cigar=false filter_mismatching_base_and_quals=false filter_bases_not_stored=false">
LINE1

h = {}
s = gatkcommandline.strip
# print s,"\n"
result = BioVcf::VcfHeaderParser::RagelKeyValues.run_lexer(s, debug: true)
# h[result['ID']] = result
# p result

lines = <<LINES
##FILTER=<ID=HaplotypeScoreHigh,Description="HaplotypeScore > 13.0">
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Total read depth",Extra="Yes?">
##FORMAT=<ID=DP4,Number=4,Type=Integer,Description="# high-quality ref-forward bases, ref-reverse, alt-forward and alt-reverse bases">
##INFO=<ID=PM,Number=0,Type=Flag,Description="Variant is Precious(Clinical,Pubmed Cited)">
##INFO=<ID=VP,Number=1,Type=String,Description="Variation Property.  Documentation is at ftp://ftp.ncbi.nlm.nih.gov/snp/specs/dbSNP_BitField_latest.pdf",Source="dbsnp",Version="138">
##INFO=<ID=GENEINFO,Number=1,Type=String,Description="Pairs each of gene symbol:gene id.  The gene symbol and id are delimited by a colon (:), and each pair is delimited by a vertical bar (|)">
##INFO=<ID=CLNHGVS,Number=.,Type=String,Description="Variant names from HGVS. The order of these variants corresponds to the order of the info in the other clinical  INFO tags.">
##INFO=<ID=CLNHGVS1,Number=.,Type=String,Description="Variant names from \\"HGVS\\". The order of these 'variants' corresponds to the order of the info in the other clinical  INFO tags.">
##contig=<ID=XXXY12>
##contig=<ID=Y,length=59373566>
LINES

h = {}
lines.strip.split("\n").each { |s|
  # print s,"\n"
  result = BioVcf::VcfHeaderParser::RagelKeyValues.run_lexer(s, debug: true)
  h[result['ID']] = result
  p result
}
p h

raise "ERROR" if h != {"HaplotypeScoreHigh"=>{"ID"=>"HaplotypeScoreHigh", "Description"=>"HaplotypeScore > 13.0"}, "GT"=>{"ID"=>"GT", "Number"=>"1", "Type"=>"String", "Description"=>"Genotype"}, "DP"=>{"ID"=>"DP", "Number"=>"1", "Type"=>"Integer", "Description"=>"Total read depth", "Extra"=>"Yes?"}, "DP4"=>{"ID"=>"DP4", "Number"=>"4", "Type"=>"Integer", "Description"=>"# high-quality ref-forward bases, ref-reverse, alt-forward and alt-reverse bases"}, "PM"=>{"ID"=>"PM", "Number"=>"0", "Type"=>"Flag", "Description"=>"Variant is Precious(Clinical,Pubmed Cited)"}, "VP"=>{"ID"=>"VP", "Number"=>"1", "Type"=>"String", "Description"=>"Variation Property.  Documentation is at ftp://ftp.ncbi.nlm.nih.gov/snp/specs/dbSNP_BitField_latest.pdf", "Source"=>"dbsnp", "Version"=>"138"}, "GENEINFO"=>{"ID"=>"GENEINFO", "Number"=>"1", "Type"=>"String", "Description"=>"Pairs each of gene symbol:gene id.  The gene symbol and id are delimited by a colon (:), and each pair is delimited by a vertical bar (|)"}, "CLNHGVS"=>{"ID"=>"CLNHGVS", "Number"=>".", "Type"=>"String", "Description"=>"Variant names from HGVS. The order of these variants corresponds to the order of the info in the other clinical  INFO tags."}, "CLNHGVS1"=>{"ID"=>"CLNHGVS1", "Number"=>".", "Type"=>"String", "Description"=>"Variant names from \\\"HGVS\\\". The order of these 'variants' corresponds to the order of the info in the other clinical  INFO tags."}, "XXXY12"=>{"ID"=>"XXXY12"}, "Y"=>{"ID"=>"Y", "length"=>59373566}}


end # test
