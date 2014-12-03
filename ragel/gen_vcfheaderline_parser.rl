# Parser for VCF-header info and format fields

module VcfHeader

  module RagelKeyValues
  
=begin
%%{

  machine simple_lexer;
  
  action mark { ts=p }
  action endquoted {
    quoted_text = data[ts...p].pack('c*')
    # do something with the quoted text!
    emit.call('string',data,ts,p)
  }

  squote = "'";
  dquote = '"';
  not_squote_or_escape = [^'\\];
  not_dquote_or_escape = [^"\\];
  escaped_something = /\\./;
  ss = space* squote ( not_squote_or_escape | escaped_something )* >mark %endquoted squote;
  dd = space* dquote ( not_dquote_or_escape | escaped_something )* >mark %endquoted dquote;

  # main := (ss | dd)*;

  integer     = ('+'|'-')?[0-9]+             >mark %{ emit.call("integer",data,ts,p)  };
  float       = ('+'|'-')?[0-9]+'.'[0-9]+    >mark %{ emit.call("float",data,ts,p) };
  assignment  = '=';
  identifier  = ([a-zA-Z][a-zA-Z_0-9]+)         >mark %{ emit.call("identifier",data,ts,p) }; 
  str         = (ss|dd)* ;       
  boolean     = '.'                          >mark %{ emit.call("bool",data,ts,p) };
  key_word    = ( ('ID'|'Number'|'Type'|'Description') >mark %{ print "*k:"; emit.call("key_word",data,ts,p) } );
  value       = ( (integer|float|boolean|identifier|str) >mark %{ print "*v:" ; emit.call("value",data,ts,p) } );

  key_value = ( key_word '=' value ) ;
  
  main := ('##FORMAT'|'##INFO') '=' (('<'|',') key_value )*;
}%%
=end

%% write data;
# %% this just fixes our syntax highlighting...

def self.run_lexer(data)
  p data
  data = data.unpack("c*") if(data.is_a?(String))
  eof = data.length
  token_array = []
  stack = []

  emit = lambda { |type, data, ts, p|
    # Print the type and text of the last read token
    # p ts,p
    puts "#{type}: #{data[ts...p].pack('c*')}"
  }

  %% write init;
  %% write exec;

  token_array.each do | h |
    p h
    # p h[:value] if h[:name]==:identifier or h[:name]==:value or h[:name]==:string
  end
end

  end
end

if __FILE__ == $0

lines = <<LINES
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Total read depth">
##FORMAT=<ID=DP4,Number=4,Type=Integer,Description="# high-quality ref-forward bases, ref-reverse, alt-forward and alt-reverse bases">
##INFO=<ID=PM,Number=0,Type=Flag,Description="Variant is Precious(Clinical,Pubmed Cited)">
##INFO=<ID=VP,Number=1,Type=String,Description="Variation Property.  Documentation is at ftp://ftp.ncbi.nlm.nih.gov/snp/specs/dbSNP_BitField_latest.pdf">
##INFO=<ID=GENEINFO,Number=1,Type=String,Description="Pairs each of gene symbol:gene id.  The gene symbol and id are delimited by a colon (:), and each pair is delimited by a vertical bar (|)">
##INFO=<ID=CLNHGVS,Number=.,Type=String,Description="Variant names from HGVS. The order of these variants corresponds to the order of the info in the other clinical  INFO tags.">
##INFO=<ID=CLNHGVS1,Number=.,Type=String,Description="Variant names from \\"HGVS\\". The order of these 'variants' corresponds to the order of the info in the other clinical  INFO tags.">
LINES

lines.strip.split("\n").each { |s| VcfHeader::RagelKeyValues.run_lexer(s) }

end