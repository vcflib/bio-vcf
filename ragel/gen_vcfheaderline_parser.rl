# Ragel lexer for VCF-header
#
# This is a partial lexer for the VCF header format. Bio-vcf uses this
# to generate meta information in (for example) JSON format. The
# advantage of using a full state engine is that it allows for easy
# parsing of key-value pairs with syntax checking and, for example,
# escaped quotes in quoted string values. This edition validates ID and
# Number fields only.

module VcfHeader

  module RagelKeyValues
  
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
  identifier  = (alpha alnum+); 
  str         = (ss|dd)* ;       
  boolean     = '.';
  key_word    = ( ('Type'|'Description'|'Source'|'Version'|identifier - ('ID'|'Number')) >mark %{ emit.call(:key_word,data,ts,p) } );
  any_value   = ( str|( integer|float|boolean|identifier >mark %{ emit.call(:value,data,ts,p) } ));
  id_value   = ( identifier >mark %{ emit.call(:value,data,ts,p) } );
  
  number_value = ( ( integer|boolean|'A'|'R'|'G' ) >mark %{ emit.call(:value,data,ts,p) } );

  id_kv     = ( ( ('ID') %kw '=' id_value ) @!{ error_code="ID"} );
  number_kv = ( ( ('Number') %kw '=' number_value ) @!{ error_code="Number"} );
  key_value = ( id_kv | number_kv | (key_word '=' any_value) ) >mark @!{ error_code="key-value" };
  
  main := ( '##' ('FILTER'|'FORMAT'|'INFO'|'ALT') '=') (('<'|',') key_value )* ;
}%%
=end

%% write data;
# %% this just fixes our syntax highlighting...

def self.run_lexer(buf, options = {})
  data = buf.unpack("c*") if(buf.is_a?(String))
  eof = data.length
  values = []
  stack = []

  emit = lambda { |type, data, ts, p|
    # Print the type and text of the last read token
    # p ts,p
    puts "#{type}: #{data[ts...p].pack('c*')}" if options[:debug]==true
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
      # p '*',a,b
      res[a[1]] = b[1]
      # p h[:value] if h[:name]==:identifier or h[:name]==:value or h[:name]==:string
    end
  rescue
    print "ERROR: "
    p values
  end
  p res
end

  end
end

if __FILE__ == $0

lines = <<LINES
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Total read depth",Extra="Yes?">
##FORMAT=<ID=DP4,Number=4,Type=Integer,Description="# high-quality ref-forward bases, ref-reverse, alt-forward and alt-reverse bases">
##INFO=<ID=PM,Number=0,Type=Flag,Description="Variant is Precious(Clinical,Pubmed Cited)">
##INFO=<ID=VP,Number=1,Type=String,Description="Variation Property.  Documentation is at ftp://ftp.ncbi.nlm.nih.gov/snp/specs/dbSNP_BitField_latest.pdf",Source="dbsnp",Version="138">
##INFO=<ID=GENEINFO,Number=1,Type=String,Description="Pairs each of gene symbol:gene id.  The gene symbol and id are delimited by a colon (:), and each pair is delimited by a vertical bar (|)">
##INFO=<ID=CLNHGVS,Number=.,Type=String,Description="Variant names from HGVS. The order of these variants corresponds to the order of the info in the other clinical  INFO tags.">
##INFO=<ID=CLNHGVS1,Number=.,Type=String,Description="Variant names from \\"HGVS\\". The order of these 'variants' corresponds to the order of the info in the other clinical  INFO tags.">
LINES

lines.strip.split("\n").each { |s|
  print s,"\n"
  VcfHeader::RagelKeyValues.run_lexer(s, debug: false)
}

end