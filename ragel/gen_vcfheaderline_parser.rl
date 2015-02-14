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
  ss = space* squote ( not_squote_or_escape | escaped_something )* >mark %endquoted squote;
  dd = space* dquote ( not_dquote_or_escape | escaped_something )* >mark %endquoted dquote;

  integer     = ('+'|'-')?digit+;
  float       = ('+'|'-')?digit+'.'digit+;
  assignment  = '=';
  identifier  = ( alnum (alnum|'.'|'_')* ); 
  str         = (ss|dd)* ;       
  boolean     = '.';
  key_word    = ( ('Type'|'Description'|'Source'|'Version'|identifier - ('ID'|'Number'|'length'|'assembly')) >mark %{ emit.call(:key_word,data,ts,p) } );
  any_value   = ( str|( integer|float|boolean|identifier >mark %{ emit.call(:value,data,ts,p) } ));
  id_value   = ( identifier >mark %{ emit.call(:value,data,ts,p) } );
  
  number_value = ( ( integer|boolean|'A'|'R'|'G' ) >mark %{ emit.call(:value,data,ts,p) } );

  id_kv     = ( ( ('ID'|'assembly') %kw '=' id_value ) %{ debug("ID FOUND") } @!{ error_code="Malformed ID"} );
  number_kv = ( ( ('Number'|'length') %kw '=' number_value ) @!{ error_code="Number"} );
  key_value = ( id_kv | number_kv | (key_word '=' any_value) ) %{ debug("KEY_VALUE found") } >mark @!{ error_code="unknown key-value " };

  main := ( '##' ('FILTER'|'FORMAT'|'contig'|'INFO'|'ALT') '=') (('<'|',') key_value )* '>';
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
      print '*',a,b if do_debug
      keyword = a[1]
      value = b[1]
      value = value.to_i if ['length'].index(keyword)
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
