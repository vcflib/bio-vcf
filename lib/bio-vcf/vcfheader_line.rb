
# line 1 "gen_vcfheaderline_parser.rl"
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
  
=begin

# line 62 "gen_vcfheaderline_parser.rl"

=end


# line 33 "gen_vcfheaderline_parser.rb"
class << self
	attr_accessor :_simple_lexer_actions
	private :_simple_lexer_actions, :_simple_lexer_actions=
end
self._simple_lexer_actions = [
	0, 1, 0, 1, 1, 1, 2, 1, 
	3, 1, 10, 1, 11, 2, 0, 1, 
	2, 4, 10, 2, 6, 10, 2, 8, 
	11, 2, 9, 11, 3, 5, 7, 10, 
	3, 8, 9, 11
]

class << self
	attr_accessor :_simple_lexer_key_offsets
	private :_simple_lexer_key_offsets, :_simple_lexer_key_offsets=
end
self._simple_lexer_key_offsets = [
	0, 0, 1, 2, 6, 7, 8, 9, 
	12, 19, 26, 43, 48, 50, 52, 60, 
	62, 64, 64, 64, 66, 72, 74, 79, 
	82, 91, 99, 106, 110, 119, 127, 135, 
	143, 151, 159, 166, 174, 176, 181, 184, 
	192, 200, 208, 216, 224, 226, 227, 228, 
	229, 230, 231, 232, 233, 234, 235, 236, 
	237, 238, 239, 240, 241
]

class << self
	attr_accessor :_simple_lexer_trans_keys
	private :_simple_lexer_trans_keys, :_simple_lexer_trans_keys=
end
self._simple_lexer_trans_keys = [
	35, 35, 65, 70, 73, 99, 76, 84, 
	61, 44, 60, 62, 73, 78, 108, 65, 
	90, 97, 122, 61, 48, 57, 65, 90, 
	97, 122, 32, 34, 39, 44, 46, 60, 
	62, 9, 13, 43, 45, 48, 57, 65, 
	90, 97, 122, 32, 34, 39, 9, 13, 
	34, 92, 34, 92, 32, 34, 39, 44, 
	60, 62, 9, 13, 39, 92, 39, 92, 
	48, 57, 44, 46, 60, 62, 48, 57, 
	48, 57, 44, 60, 62, 48, 57, 44, 
	60, 62, 44, 60, 62, 48, 57, 65, 
	90, 97, 122, 61, 68, 48, 57, 65, 
	90, 97, 122, 61, 48, 57, 65, 90, 
	97, 122, 65, 90, 97, 122, 44, 60, 
	62, 48, 57, 65, 90, 97, 122, 61, 
	117, 48, 57, 65, 90, 97, 122, 61, 
	109, 48, 57, 65, 90, 97, 122, 61, 
	98, 48, 57, 65, 90, 97, 122, 61, 
	101, 48, 57, 65, 90, 97, 122, 61, 
	114, 48, 57, 65, 90, 97, 122, 61, 
	48, 57, 65, 90, 97, 122, 43, 45, 
	46, 65, 71, 82, 48, 57, 48, 57, 
	44, 60, 62, 48, 57, 44, 60, 62, 
	61, 101, 48, 57, 65, 90, 97, 122, 
	61, 110, 48, 57, 65, 90, 97, 122, 
	61, 103, 48, 57, 65, 90, 97, 122, 
	61, 116, 48, 57, 65, 90, 97, 122, 
	61, 104, 48, 57, 65, 90, 97, 122, 
	73, 79, 76, 84, 69, 82, 82, 77, 
	65, 78, 70, 79, 111, 110, 116, 105, 
	103, 0
]

class << self
	attr_accessor :_simple_lexer_single_lengths
	private :_simple_lexer_single_lengths, :_simple_lexer_single_lengths=
end
self._simple_lexer_single_lengths = [
	0, 1, 1, 4, 1, 1, 1, 3, 
	3, 1, 7, 3, 2, 2, 6, 2, 
	2, 0, 0, 0, 4, 0, 3, 3, 
	3, 2, 1, 0, 3, 2, 2, 2, 
	2, 2, 1, 6, 0, 3, 3, 2, 
	2, 2, 2, 2, 2, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 0
]

class << self
	attr_accessor :_simple_lexer_range_lengths
	private :_simple_lexer_range_lengths, :_simple_lexer_range_lengths=
end
self._simple_lexer_range_lengths = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	2, 3, 5, 1, 0, 0, 1, 0, 
	0, 0, 0, 1, 1, 1, 1, 0, 
	3, 3, 3, 2, 3, 3, 3, 3, 
	3, 3, 3, 1, 1, 1, 0, 3, 
	3, 3, 3, 3, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0
]

class << self
	attr_accessor :_simple_lexer_index_offsets
	private :_simple_lexer_index_offsets, :_simple_lexer_index_offsets=
end
self._simple_lexer_index_offsets = [
	0, 0, 2, 4, 9, 11, 13, 15, 
	19, 25, 30, 43, 48, 51, 54, 62, 
	65, 68, 69, 70, 72, 78, 80, 85, 
	89, 96, 102, 107, 110, 117, 123, 129, 
	135, 141, 147, 152, 160, 162, 167, 171, 
	177, 183, 189, 195, 201, 204, 206, 208, 
	210, 212, 214, 216, 218, 220, 222, 224, 
	226, 228, 230, 232, 234
]

class << self
	attr_accessor :_simple_lexer_indicies
	private :_simple_lexer_indicies, :_simple_lexer_indicies=
end
self._simple_lexer_indicies = [
	0, 1, 2, 1, 3, 4, 5, 6, 
	1, 7, 1, 8, 1, 9, 1, 10, 
	10, 11, 1, 14, 15, 16, 13, 13, 
	12, 19, 18, 18, 18, 17, 20, 21, 
	22, 24, 25, 24, 27, 20, 23, 26, 
	28, 28, 1, 20, 21, 22, 20, 17, 
	30, 31, 29, 33, 34, 32, 20, 21, 
	22, 24, 24, 27, 20, 1, 30, 36, 
	35, 33, 38, 37, 37, 32, 26, 17, 
	24, 39, 24, 27, 26, 1, 40, 17, 
	24, 24, 27, 40, 1, 24, 24, 27, 
	1, 41, 41, 43, 42, 42, 42, 1, 
	19, 45, 18, 18, 18, 44, 46, 18, 
	18, 18, 44, 47, 47, 44, 48, 48, 
	50, 49, 49, 49, 1, 19, 52, 18, 
	18, 18, 51, 19, 53, 18, 18, 18, 
	51, 19, 54, 18, 18, 18, 51, 19, 
	55, 18, 18, 18, 51, 19, 56, 18, 
	18, 18, 51, 57, 18, 18, 18, 51, 
	58, 58, 59, 59, 59, 59, 60, 51, 
	61, 51, 62, 62, 63, 61, 1, 62, 
	62, 63, 1, 19, 64, 18, 18, 18, 
	51, 19, 65, 18, 18, 18, 51, 19, 
	66, 18, 18, 18, 51, 19, 67, 18, 
	18, 18, 51, 19, 56, 18, 18, 18, 
	51, 68, 69, 1, 70, 1, 71, 1, 
	72, 1, 8, 1, 73, 1, 74, 1, 
	7, 1, 75, 1, 76, 1, 8, 1, 
	77, 1, 78, 1, 79, 1, 80, 1, 
	8, 1, 1, 0
]

class << self
	attr_accessor :_simple_lexer_trans_targs
	private :_simple_lexer_trans_targs, :_simple_lexer_trans_targs=
end
self._simple_lexer_trans_targs = [
	2, 0, 3, 4, 44, 52, 55, 5, 
	6, 7, 8, 60, 0, 9, 25, 29, 
	39, 0, 9, 10, 11, 12, 15, 19, 
	8, 23, 20, 60, 24, 13, 14, 18, 
	13, 14, 18, 16, 17, 16, 17, 21, 
	22, 8, 24, 60, 0, 26, 27, 28, 
	8, 28, 60, 0, 30, 31, 32, 33, 
	34, 35, 36, 38, 37, 37, 8, 60, 
	40, 41, 42, 43, 45, 49, 46, 47, 
	48, 50, 51, 53, 54, 56, 57, 58, 
	59
]

class << self
	attr_accessor :_simple_lexer_trans_actions
	private :_simple_lexer_trans_actions, :_simple_lexer_trans_actions=
end
self._simple_lexer_trans_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 32, 1, 1, 1, 
	1, 11, 0, 7, 0, 0, 0, 0, 
	9, 0, 0, 9, 1, 1, 13, 1, 
	0, 3, 0, 1, 1, 0, 0, 0, 
	0, 16, 0, 16, 22, 0, 5, 1, 
	28, 0, 28, 25, 0, 0, 0, 0, 
	0, 5, 1, 1, 1, 0, 19, 19, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0
]

class << self
	attr_accessor :_simple_lexer_eof_actions
	private :_simple_lexer_eof_actions, :_simple_lexer_eof_actions=
end
self._simple_lexer_eof_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	32, 11, 0, 11, 11, 11, 0, 11, 
	11, 11, 11, 11, 0, 11, 0, 0, 
	0, 22, 22, 22, 0, 25, 25, 25, 
	25, 25, 25, 25, 25, 0, 0, 25, 
	25, 25, 25, 25, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0
]

class << self
	attr_accessor :simple_lexer_start
end
self.simple_lexer_start = 1;
class << self
	attr_accessor :simple_lexer_first_final
end
self.simple_lexer_first_final = 60;
class << self
	attr_accessor :simple_lexer_error
end
self.simple_lexer_error = 0;

class << self
	attr_accessor :simple_lexer_en_main
end
self.simple_lexer_en_main = 1;


# line 66 "gen_vcfheaderline_parser.rl"
# %% this just fixes syntax highlighting...

def self.run_lexer(buf, options = {})
  do_debug = (options[:debug] == true)
  data = buf.unpack("c*") if(buf.is_a?(String))
  eof = data.length
  values = []
  stack = []

  emit = lambda { |type, data, ts, p|
    # Print the type and text of the last read token
    # p ts,p
    puts "#{type}: #{data[ts...p].pack('c*')}" if do_debug
    values << [type,data[ts...p].pack('c*')]
  }

  error_code = nil
  
  
# line 271 "gen_vcfheaderline_parser.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = simple_lexer_start
end

# line 85 "gen_vcfheaderline_parser.rl"
  
# line 280 "gen_vcfheaderline_parser.rb"
begin
	_klen, _trans, _keys, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	_trigger_goto = false
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	end
	if _goto_level <= _resume
	_keys = _simple_lexer_key_offsets[cs]
	_trans = _simple_lexer_index_offsets[cs]
	_klen = _simple_lexer_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if data[p].ord < _simple_lexer_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif data[p].ord > _simple_lexer_trans_keys[_mid]
	           _lower = _mid + 1
	        else
	           _trans += (_mid - _keys)
	           _break_match = true
	           break
	        end
	     end # loop
	     break if _break_match
	     _keys += _klen
	     _trans += _klen
	  end
	  _klen = _simple_lexer_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if data[p].ord < _simple_lexer_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif data[p].ord > _simple_lexer_trans_keys[_mid+1]
	          _lower = _mid + 2
	        else
	          _trans += ((_mid - _keys) >> 1)
	          _break_match = true
	          break
	        end
	     end # loop
	     break if _break_match
	     _trans += _klen
	  end
	end while false
	_trans = _simple_lexer_indicies[_trans]
	cs = _simple_lexer_trans_targs[_trans]
	if _simple_lexer_trans_actions[_trans] != 0
		_acts = _simple_lexer_trans_actions[_trans]
		_nacts = _simple_lexer_actions[_acts]
		_acts += 1
		while _nacts > 0
			_nacts -= 1
			_acts += 1
			case _simple_lexer_actions[_acts - 1]
when 0 then
# line 28 "gen_vcfheaderline_parser.rl"
		begin
 ts=p 		end
when 1 then
# line 29 "gen_vcfheaderline_parser.rl"
		begin

    emit.call(:value,data,ts,p)
  		end
when 2 then
# line 33 "gen_vcfheaderline_parser.rl"
		begin

    emit.call(:kw,data,ts,p)
  		end
when 3 then
# line 51 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:key_word,data,ts,p) 		end
when 4 then
# line 52 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:value,data,ts,p) 		end
when 5 then
# line 53 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:value,data,ts,p) 		end
when 6 then
# line 55 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:value,data,ts,p) 		end
when 7 then
# line 57 "gen_vcfheaderline_parser.rl"
		begin
 p "ID FOUND" 		end
when 8 then
# line 57 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Malformed ID"		end
when 9 then
# line 58 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Number"		end
when 10 then
# line 59 "gen_vcfheaderline_parser.rl"
		begin
 p "KEY_VALUE found" 		end
when 11 then
# line 59 "gen_vcfheaderline_parser.rl"
		begin
 error_code="unknown key-value " 		end
# line 413 "gen_vcfheaderline_parser.rb"
			end # action switch
		end
	end
	if _trigger_goto
		next
	end
	end
	if _goto_level <= _again
	if cs == 0
		_goto_level = _out
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	if p == eof
	__acts = _simple_lexer_eof_actions[cs]
	__nacts =  _simple_lexer_actions[__acts]
	__acts += 1
	while __nacts > 0
		__nacts -= 1
		__acts += 1
		case _simple_lexer_actions[__acts - 1]
when 8 then
# line 57 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Malformed ID"		end
when 9 then
# line 58 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Number"		end
when 11 then
# line 59 "gen_vcfheaderline_parser.rl"
		begin
 error_code="unknown key-value " 		end
# line 453 "gen_vcfheaderline_parser.rb"
		end # eof action switch
	end
	if _trigger_goto
		next
	end
end
	end
	if _goto_level <= _out
		break
	end
	end
	end

# line 86 "gen_vcfheaderline_parser.rl"

  raise "ERROR: "+error_code+" in "+buf if error_code

  begin
    res = {}
    # p values
    values.each_slice(2) do | a,b |
      print '*',a,b
      res[a[1]] = b[1]
      # p h[:value] if h[:name]==:identifier or h[:name]==:value or h[:name]==:string
    end
  rescue
    print "ERROR: "
    p values
    raise
  end
  p res if do_debug
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

lines.strip.split("\n").each { |s|
  print s,"\n"
  p BioVcf::VcfHeaderParser::RagelKeyValues.run_lexer(s, debug: true)
}

end # test
