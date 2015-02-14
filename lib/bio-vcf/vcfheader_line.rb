
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

      def self.debug msg
        # nothing
      end
      
=begin

# line 66 "gen_vcfheaderline_parser.rl"

=end


# line 37 "gen_vcfheaderline_parser.rb"
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
	12, 22, 31, 48, 53, 55, 57, 65, 
	67, 69, 69, 69, 71, 77, 79, 84, 
	87, 98, 108, 117, 123, 134, 144, 154, 
	164, 174, 184, 193, 201, 203, 208, 211, 
	221, 231, 241, 251, 261, 271, 281, 291, 
	301, 311, 321, 331, 333, 334, 335, 336, 
	337, 338, 339, 340, 341, 342, 343, 344, 
	345, 346, 347, 348
]

class << self
	attr_accessor :_simple_lexer_trans_keys
	private :_simple_lexer_trans_keys, :_simple_lexer_trans_keys=
end
self._simple_lexer_trans_keys = [
	35, 35, 65, 70, 73, 99, 76, 84, 
	61, 44, 60, 62, 73, 78, 97, 108, 
	48, 57, 65, 90, 98, 122, 46, 61, 
	95, 48, 57, 65, 90, 97, 122, 32, 
	34, 39, 44, 46, 60, 62, 9, 13, 
	43, 45, 48, 57, 65, 90, 97, 122, 
	32, 34, 39, 9, 13, 34, 92, 34, 
	92, 32, 34, 39, 44, 60, 62, 9, 
	13, 39, 92, 39, 92, 48, 57, 44, 
	46, 60, 62, 48, 57, 48, 57, 44, 
	60, 62, 48, 57, 44, 60, 62, 44, 
	46, 60, 62, 95, 48, 57, 65, 90, 
	97, 122, 46, 61, 68, 95, 48, 57, 
	65, 90, 97, 122, 46, 61, 95, 48, 
	57, 65, 90, 97, 122, 48, 57, 65, 
	90, 97, 122, 44, 46, 60, 62, 95, 
	48, 57, 65, 90, 97, 122, 46, 61, 
	95, 117, 48, 57, 65, 90, 97, 122, 
	46, 61, 95, 109, 48, 57, 65, 90, 
	97, 122, 46, 61, 95, 98, 48, 57, 
	65, 90, 97, 122, 46, 61, 95, 101, 
	48, 57, 65, 90, 97, 122, 46, 61, 
	95, 114, 48, 57, 65, 90, 97, 122, 
	46, 61, 95, 48, 57, 65, 90, 97, 
	122, 43, 45, 46, 65, 71, 82, 48, 
	57, 48, 57, 44, 60, 62, 48, 57, 
	44, 60, 62, 46, 61, 95, 115, 48, 
	57, 65, 90, 97, 122, 46, 61, 95, 
	115, 48, 57, 65, 90, 97, 122, 46, 
	61, 95, 101, 48, 57, 65, 90, 97, 
	122, 46, 61, 95, 109, 48, 57, 65, 
	90, 97, 122, 46, 61, 95, 98, 48, 
	57, 65, 90, 97, 122, 46, 61, 95, 
	108, 48, 57, 65, 90, 97, 122, 46, 
	61, 95, 121, 48, 57, 65, 90, 97, 
	122, 46, 61, 95, 101, 48, 57, 65, 
	90, 97, 122, 46, 61, 95, 110, 48, 
	57, 65, 90, 97, 122, 46, 61, 95, 
	103, 48, 57, 65, 90, 97, 122, 46, 
	61, 95, 116, 48, 57, 65, 90, 97, 
	122, 46, 61, 95, 104, 48, 57, 65, 
	90, 97, 122, 73, 79, 76, 84, 69, 
	82, 82, 77, 65, 78, 70, 79, 111, 
	110, 116, 105, 103, 0
]

class << self
	attr_accessor :_simple_lexer_single_lengths
	private :_simple_lexer_single_lengths, :_simple_lexer_single_lengths=
end
self._simple_lexer_single_lengths = [
	0, 1, 1, 4, 1, 1, 1, 3, 
	4, 3, 7, 3, 2, 2, 6, 2, 
	2, 0, 0, 0, 4, 0, 3, 3, 
	5, 4, 3, 0, 5, 4, 4, 4, 
	4, 4, 3, 6, 0, 3, 3, 4, 
	4, 4, 4, 4, 4, 4, 4, 4, 
	4, 4, 4, 2, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 0
]

class << self
	attr_accessor :_simple_lexer_range_lengths
	private :_simple_lexer_range_lengths, :_simple_lexer_range_lengths=
end
self._simple_lexer_range_lengths = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	3, 3, 5, 1, 0, 0, 1, 0, 
	0, 0, 0, 1, 1, 1, 1, 0, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 1, 1, 1, 0, 3, 
	3, 3, 3, 3, 3, 3, 3, 3, 
	3, 3, 3, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0
]

class << self
	attr_accessor :_simple_lexer_index_offsets
	private :_simple_lexer_index_offsets, :_simple_lexer_index_offsets=
end
self._simple_lexer_index_offsets = [
	0, 0, 2, 4, 9, 11, 13, 15, 
	19, 27, 34, 47, 52, 55, 58, 66, 
	69, 72, 73, 74, 76, 82, 84, 89, 
	93, 102, 110, 117, 121, 130, 138, 146, 
	154, 162, 170, 177, 185, 187, 192, 196, 
	204, 212, 220, 228, 236, 244, 252, 260, 
	268, 276, 284, 292, 295, 297, 299, 301, 
	303, 305, 307, 309, 311, 313, 315, 317, 
	319, 321, 323, 325
]

class << self
	attr_accessor :_simple_lexer_indicies
	private :_simple_lexer_indicies, :_simple_lexer_indicies=
end
self._simple_lexer_indicies = [
	0, 1, 2, 1, 3, 4, 5, 6, 
	1, 7, 1, 8, 1, 9, 1, 10, 
	10, 11, 1, 14, 15, 16, 17, 13, 
	13, 13, 12, 19, 20, 19, 19, 19, 
	19, 18, 21, 22, 23, 25, 26, 25, 
	28, 21, 24, 27, 27, 27, 1, 21, 
	22, 23, 21, 18, 30, 31, 29, 33, 
	34, 32, 21, 22, 23, 25, 25, 28, 
	21, 1, 30, 36, 35, 33, 38, 37, 
	37, 32, 39, 18, 25, 40, 25, 28, 
	39, 1, 41, 18, 25, 25, 28, 41, 
	1, 25, 25, 28, 1, 42, 43, 42, 
	44, 43, 43, 43, 43, 1, 19, 20, 
	46, 19, 19, 19, 19, 45, 19, 47, 
	19, 19, 19, 19, 45, 48, 48, 48, 
	45, 49, 50, 49, 51, 50, 50, 50, 
	50, 1, 19, 20, 19, 53, 19, 19, 
	19, 52, 19, 20, 19, 54, 19, 19, 
	19, 52, 19, 20, 19, 55, 19, 19, 
	19, 52, 19, 20, 19, 56, 19, 19, 
	19, 52, 19, 20, 19, 57, 19, 19, 
	19, 52, 19, 58, 19, 19, 19, 19, 
	52, 59, 59, 60, 60, 60, 60, 61, 
	52, 62, 52, 63, 63, 64, 62, 1, 
	63, 63, 64, 1, 19, 20, 19, 65, 
	19, 19, 19, 45, 19, 20, 19, 66, 
	19, 19, 19, 45, 19, 20, 19, 67, 
	19, 19, 19, 45, 19, 20, 19, 68, 
	19, 19, 19, 45, 19, 20, 19, 69, 
	19, 19, 19, 45, 19, 20, 19, 70, 
	19, 19, 19, 45, 19, 20, 19, 46, 
	19, 19, 19, 45, 19, 20, 19, 71, 
	19, 19, 19, 52, 19, 20, 19, 72, 
	19, 19, 19, 52, 19, 20, 19, 73, 
	19, 19, 19, 52, 19, 20, 19, 74, 
	19, 19, 19, 52, 19, 20, 19, 57, 
	19, 19, 19, 52, 75, 76, 1, 77, 
	1, 78, 1, 79, 1, 8, 1, 80, 
	1, 81, 1, 7, 1, 82, 1, 83, 
	1, 8, 1, 84, 1, 85, 1, 86, 
	1, 87, 1, 8, 1, 1, 0
]

class << self
	attr_accessor :_simple_lexer_trans_targs
	private :_simple_lexer_trans_targs, :_simple_lexer_trans_targs=
end
self._simple_lexer_trans_targs = [
	2, 0, 3, 4, 51, 59, 62, 5, 
	6, 7, 8, 67, 0, 9, 25, 29, 
	39, 46, 0, 9, 10, 11, 12, 15, 
	19, 8, 23, 24, 67, 13, 14, 18, 
	13, 14, 18, 16, 17, 16, 17, 20, 
	21, 22, 8, 24, 67, 0, 26, 27, 
	28, 8, 28, 67, 0, 30, 31, 32, 
	33, 34, 35, 36, 38, 37, 37, 8, 
	67, 40, 41, 42, 43, 44, 45, 47, 
	48, 49, 50, 52, 56, 53, 54, 55, 
	57, 58, 60, 61, 63, 64, 65, 66
]

class << self
	attr_accessor :_simple_lexer_trans_actions
	private :_simple_lexer_trans_actions, :_simple_lexer_trans_actions=
end
self._simple_lexer_trans_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 32, 1, 1, 1, 
	1, 1, 11, 0, 7, 0, 0, 0, 
	0, 9, 0, 1, 9, 1, 13, 1, 
	0, 3, 0, 1, 1, 0, 0, 0, 
	0, 0, 16, 0, 16, 22, 0, 5, 
	1, 28, 0, 28, 25, 0, 0, 0, 
	0, 0, 5, 1, 1, 1, 0, 19, 
	19, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0
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
	25, 25, 25, 25, 25, 0, 0, 22, 
	22, 22, 22, 22, 22, 22, 25, 25, 
	25, 25, 25, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0
]

class << self
	attr_accessor :simple_lexer_start
end
self.simple_lexer_start = 1;
class << self
	attr_accessor :simple_lexer_first_final
end
self.simple_lexer_first_final = 67;
class << self
	attr_accessor :simple_lexer_error
end
self.simple_lexer_error = 0;

class << self
	attr_accessor :simple_lexer_en_main
end
self.simple_lexer_en_main = 1;


# line 70 "gen_vcfheaderline_parser.rl"
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
    $stderr.print "#{type}: #{data[ts...p].pack('c*')}\n" if do_debug
    values << [type,data[ts...p].pack('c*')]
  }

  error_code = nil
  
  
# line 305 "gen_vcfheaderline_parser.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = simple_lexer_start
end

# line 90 "gen_vcfheaderline_parser.rl"
  
# line 314 "gen_vcfheaderline_parser.rb"
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
# line 32 "gen_vcfheaderline_parser.rl"
		begin
 ts=p 		end
when 1 then
# line 33 "gen_vcfheaderline_parser.rl"
		begin

    emit.call(:value,data,ts,p)
  		end
when 2 then
# line 37 "gen_vcfheaderline_parser.rl"
		begin

    emit.call(:kw,data,ts,p)
  		end
when 3 then
# line 55 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:key_word,data,ts,p) 		end
when 4 then
# line 56 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:value,data,ts,p) 		end
when 5 then
# line 57 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:value,data,ts,p) 		end
when 6 then
# line 59 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:value,data,ts,p) 		end
when 7 then
# line 61 "gen_vcfheaderline_parser.rl"
		begin
 debug("ID FOUND") 		end
when 8 then
# line 61 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Malformed ID"		end
when 9 then
# line 62 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Number"		end
when 10 then
# line 63 "gen_vcfheaderline_parser.rl"
		begin
 debug("KEY_VALUE found") 		end
when 11 then
# line 63 "gen_vcfheaderline_parser.rl"
		begin
 error_code="unknown key-value " 		end
# line 447 "gen_vcfheaderline_parser.rb"
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
# line 61 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Malformed ID"		end
when 9 then
# line 62 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Number"		end
when 11 then
# line 63 "gen_vcfheaderline_parser.rl"
		begin
 error_code="unknown key-value " 		end
# line 487 "gen_vcfheaderline_parser.rb"
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

# line 91 "gen_vcfheaderline_parser.rl"

  raise "ERROR: "+error_code+" in "+buf if error_code

  begin
    res = {}
    # p values
    values.each_slice(2) do | a,b |
      print '*',a,b if do_debug
      res[a[1]] = b[1]
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

lines.strip.split("\n").each { |s|
  # print s,"\n"
  p BioVcf::VcfHeaderParser::RagelKeyValues.run_lexer(s, debug: true)
}

end # test
