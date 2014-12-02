# Parser for VCF-header info and format fields

=begin
%%{

  machine simple_lexer;
  

  action mark { ts=p }
  integer     = ('+'|'-')?[0-9]+             >mark %{ emit("integer",data,ts,p)  };
  float       = ('+'|'-')?[0-9]+'.'[0-9]+    >mark %{ emit("float",data,ts,p) };
  assignment  = '=';
  identifier  = ([a-zA-Z][a-zA-Z_]+)         >mark %{ emit("identifier",data,ts,p) }; 
  string      = (["][^"]*["])                >mark %{ emit("string",data,ts,p) };
  boolean     = '.'                          >mark %{ emit("bool",data,ts,p) };
  key_word    = ( ('ID'|'Number'|'Type'|'Description') >mark %{ print "*k:"; emit("key_word",data,ts,p) } );
  value       = ( (integer|float|boolean|identifier|string) >mark %{ print "*v:" ; emit("value",data,ts,p) } );

  key_value = ( key_word '=' value ) ;
  
  main := ( ('<'|',') key_value )*;
}%%
=end

%% write data;
# %% this just fixes our syntax highlighting...


def emit type, data, ts, p
  # Print the type and text of the last read token
  # p ts,p
  puts "#{type}: #{data[ts...p].pack('c*')}"
end
      
def xemit(token_name, data, target_array, ts, te)
  target_array << {:name => token_name.to_sym, :value => data.pack("c*")[ts...te] }
end

def run_lexer(data)
  p data
  data = data.unpack("c*") if(data.is_a?(String))
  eof = data.length
  token_array = []
  stack = []
  
  %% write init;
  %% write exec;

  p token_array
  token_array.each do | h |
    p h
    # p h[:value] if h[:name]==:identifier or h[:name]==:value or h[:name]==:string
  end
end

# run_lexer("value = -2.00")

lines = <<LINES
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Total read depth">
##FORMAT=<ID=DP4,Number=4,Type=Integer,Description="# high-quality ref-forward bases, ref-reverse, alt-forward and alt-reverse bases">
##INFO=<ID=PM,Number=0,Type=Flag,Description="Variant is Precious(Clinical,Pubmed Cited)">
##INFO=<ID=VP,Number=1,Type=String,Description="Variation Property.  Documentation is at ftp://ftp.ncbi.nlm.nih.gov/snp/specs/dbSNP_BitField_latest.pdf">
##INFO=<ID=GENEINFO,Number=1,Type=String,Description="Pairs each of gene symbol:gene id.  The gene symbol and id are delimited by a colon (:), and each pair is delimited by a vertical bar (|)">
##INFO=<ID=CLNHGVS,Number=.,Type=String,Description="Variant names from HGVS. The order of these variants corresponds to the order of the info in the other clinical  INFO tags.">
LINES

lines.strip.split("\n").each { |s| run_lexer(s.sub(/^##(FORMAT|INFO)=/,'')) }

cmd=ARGV.shift
run_lexer(cmd)

