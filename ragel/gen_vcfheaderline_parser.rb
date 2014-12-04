
# line 1 "gen_vcfheaderline_parser.rl"
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

# line 53 "gen_vcfheaderline_parser.rl"

=end


# line 24 "gen_vcfheaderline_parser.rb"
class << self
	attr_accessor :_simple_lexer_actions
	private :_simple_lexer_actions, :_simple_lexer_actions=
end
self._simple_lexer_actions = [
	0, 1, 0, 1, 1, 1, 2, 1, 
	3, 1, 4, 1, 5, 1, 6, 1, 
	9, 2, 0, 1, 2, 7, 9, 2, 
	8, 9, 3, 7, 8, 9
]

class << self
	attr_accessor :_simple_lexer_key_offsets
	private :_simple_lexer_key_offsets, :_simple_lexer_key_offsets=
end
self._simple_lexer_key_offsets = [
	0, 0, 1, 2, 5, 6, 7, 8, 
	14, 20, 27, 32, 34, 36, 38, 40, 
	40, 40, 42, 44, 50, 57, 64, 68, 
	74, 81, 89, 97, 105, 113, 120, 128, 
	130, 132, 133, 134, 135, 136, 137, 138, 
	139, 140, 141, 142, 144, 160, 167, 172, 
	176, 184, 192, 196
]

class << self
	attr_accessor :_simple_lexer_trans_keys
	private :_simple_lexer_trans_keys, :_simple_lexer_trans_keys=
end
self._simple_lexer_trans_keys = [
	35, 35, 65, 70, 73, 76, 84, 61, 
	73, 78, 65, 90, 97, 122, 48, 57, 
	65, 90, 97, 122, 61, 48, 57, 65, 
	90, 97, 122, 32, 34, 39, 9, 13, 
	34, 92, 34, 92, 39, 92, 39, 92, 
	48, 57, 48, 57, 48, 57, 65, 90, 
	97, 122, 68, 48, 57, 65, 90, 97, 
	122, 61, 48, 57, 65, 90, 97, 122, 
	65, 90, 97, 122, 48, 57, 65, 90, 
	97, 122, 117, 48, 57, 65, 90, 97, 
	122, 61, 109, 48, 57, 65, 90, 97, 
	122, 61, 98, 48, 57, 65, 90, 97, 
	122, 61, 101, 48, 57, 65, 90, 97, 
	122, 61, 114, 48, 57, 65, 90, 97, 
	122, 61, 48, 57, 65, 90, 97, 122, 
	43, 45, 46, 65, 71, 82, 48, 57, 
	48, 57, 73, 79, 76, 84, 69, 82, 
	82, 77, 65, 78, 70, 79, 44, 60, 
	32, 34, 39, 44, 46, 60, 9, 13, 
	43, 45, 48, 57, 65, 90, 97, 122, 
	32, 34, 39, 44, 60, 9, 13, 44, 
	46, 60, 48, 57, 44, 60, 48, 57, 
	44, 60, 48, 57, 65, 90, 97, 122, 
	44, 60, 48, 57, 65, 90, 97, 122, 
	44, 60, 48, 57, 44, 60, 0
]

class << self
	attr_accessor :_simple_lexer_single_lengths
	private :_simple_lexer_single_lengths, :_simple_lexer_single_lengths=
end
self._simple_lexer_single_lengths = [
	0, 1, 1, 3, 1, 1, 1, 2, 
	0, 1, 3, 2, 2, 2, 2, 0, 
	0, 0, 0, 0, 1, 1, 0, 0, 
	1, 2, 2, 2, 2, 1, 6, 0, 
	2, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 2, 6, 5, 3, 2, 
	2, 2, 2, 2
]

class << self
	attr_accessor :_simple_lexer_range_lengths
	private :_simple_lexer_range_lengths, :_simple_lexer_range_lengths=
end
self._simple_lexer_range_lengths = [
	0, 0, 0, 0, 0, 0, 0, 2, 
	3, 3, 1, 0, 0, 0, 0, 0, 
	0, 1, 1, 3, 3, 3, 2, 3, 
	3, 3, 3, 3, 3, 3, 1, 1, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 5, 1, 1, 1, 
	3, 3, 1, 0
]

class << self
	attr_accessor :_simple_lexer_index_offsets
	private :_simple_lexer_index_offsets, :_simple_lexer_index_offsets=
end
self._simple_lexer_index_offsets = [
	0, 0, 2, 4, 8, 10, 12, 14, 
	19, 23, 28, 33, 36, 39, 42, 45, 
	46, 47, 49, 51, 55, 60, 65, 68, 
	72, 77, 83, 89, 95, 101, 106, 114, 
	116, 119, 121, 123, 125, 127, 129, 131, 
	133, 135, 137, 139, 142, 154, 161, 166, 
	170, 176, 182, 186
]

class << self
	attr_accessor :_simple_lexer_indicies
	private :_simple_lexer_indicies, :_simple_lexer_indicies=
end
self._simple_lexer_indicies = [
	0, 1, 2, 1, 3, 4, 5, 1, 
	6, 1, 7, 1, 8, 1, 11, 12, 
	10, 10, 9, 14, 14, 14, 13, 15, 
	14, 14, 14, 13, 16, 17, 18, 16, 
	13, 20, 21, 19, 23, 24, 22, 20, 
	26, 25, 23, 28, 27, 27, 22, 29, 
	13, 30, 13, 31, 31, 31, 13, 33, 
	14, 14, 14, 32, 34, 14, 14, 14, 
	32, 35, 35, 32, 36, 36, 36, 32, 
	38, 14, 14, 14, 37, 15, 39, 14, 
	14, 14, 37, 15, 40, 14, 14, 14, 
	37, 15, 41, 14, 14, 14, 37, 15, 
	42, 14, 14, 14, 37, 43, 14, 14, 
	14, 37, 44, 44, 45, 45, 45, 45, 
	46, 37, 47, 37, 48, 49, 1, 50, 
	1, 51, 1, 52, 1, 7, 1, 53, 
	1, 54, 1, 6, 1, 55, 1, 56, 
	1, 7, 1, 57, 57, 1, 16, 17, 
	18, 57, 8, 57, 16, 58, 29, 59, 
	59, 1, 16, 17, 18, 57, 57, 16, 
	1, 57, 60, 57, 29, 1, 57, 57, 
	30, 1, 61, 61, 31, 31, 31, 1, 
	62, 62, 36, 36, 36, 1, 63, 63, 
	47, 1, 63, 63, 1, 0
]

class << self
	attr_accessor :_simple_lexer_trans_targs
	private :_simple_lexer_trans_targs, :_simple_lexer_trans_targs=
end
self._simple_lexer_trans_targs = [
	2, 0, 3, 4, 32, 40, 5, 6, 
	43, 0, 8, 20, 24, 0, 9, 44, 
	10, 11, 13, 12, 45, 16, 12, 45, 
	16, 14, 15, 14, 15, 46, 47, 48, 
	0, 21, 22, 23, 49, 0, 25, 26, 
	27, 28, 29, 30, 31, 51, 50, 50, 
	33, 37, 34, 35, 36, 38, 39, 41, 
	42, 7, 17, 19, 18, 7, 7, 7
]

class << self
	attr_accessor :_simple_lexer_trans_actions
	private :_simple_lexer_trans_actions, :_simple_lexer_trans_actions=
end
self._simple_lexer_trans_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 26, 1, 1, 1, 15, 0, 7, 
	0, 0, 0, 1, 17, 1, 0, 3, 
	0, 1, 1, 0, 0, 0, 0, 0, 
	20, 0, 5, 1, 0, 23, 0, 0, 
	0, 0, 0, 5, 1, 1, 1, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 1, 0, 9, 11, 13
]

class << self
	attr_accessor :_simple_lexer_eof_actions
	private :_simple_lexer_eof_actions, :_simple_lexer_eof_actions=
end
self._simple_lexer_eof_actions = [
	0, 0, 0, 0, 0, 0, 0, 26, 
	15, 15, 15, 15, 15, 15, 15, 15, 
	15, 15, 15, 15, 20, 20, 20, 20, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	9, 11, 13, 13
]

class << self
	attr_accessor :simple_lexer_start
end
self.simple_lexer_start = 1;
class << self
	attr_accessor :simple_lexer_first_final
end
self.simple_lexer_first_final = 43;
class << self
	attr_accessor :simple_lexer_error
end
self.simple_lexer_error = 0;

class << self
	attr_accessor :simple_lexer_en_main
end
self.simple_lexer_en_main = 1;


# line 57 "gen_vcfheaderline_parser.rl"
# %% this just fixes our syntax highlighting...

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
  
  
# line 238 "gen_vcfheaderline_parser.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = simple_lexer_start
end

# line 76 "gen_vcfheaderline_parser.rl"
  
# line 247 "gen_vcfheaderline_parser.rb"
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
# line 19 "gen_vcfheaderline_parser.rl"
		begin
 ts=p 		end
when 1 then
# line 20 "gen_vcfheaderline_parser.rl"
		begin

    emit.call(:value,data,ts,p)
  		end
when 2 then
# line 24 "gen_vcfheaderline_parser.rl"
		begin

    emit.call(:kw,data,ts,p)
  		end
when 3 then
# line 42 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:key_word,data,ts,p) 		end
when 4 then
# line 43 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:value,data,ts,p) 		end
when 5 then
# line 44 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:value,data,ts,p) 		end
when 6 then
# line 46 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:value,data,ts,p) 		end
when 7 then
# line 48 "gen_vcfheaderline_parser.rl"
		begin
 error_code="ID"		end
when 8 then
# line 49 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Number"		end
when 9 then
# line 50 "gen_vcfheaderline_parser.rl"
		begin
 error_code="key-value" 		end
# line 372 "gen_vcfheaderline_parser.rb"
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
when 4 then
# line 43 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:value,data,ts,p) 		end
when 5 then
# line 44 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:value,data,ts,p) 		end
when 6 then
# line 46 "gen_vcfheaderline_parser.rl"
		begin
 emit.call(:value,data,ts,p) 		end
when 7 then
# line 48 "gen_vcfheaderline_parser.rl"
		begin
 error_code="ID"		end
when 8 then
# line 49 "gen_vcfheaderline_parser.rl"
		begin
 error_code="Number"		end
when 9 then
# line 50 "gen_vcfheaderline_parser.rl"
		begin
 error_code="key-value" 		end
# line 424 "gen_vcfheaderline_parser.rb"
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

# line 77 "gen_vcfheaderline_parser.rl"

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
    raise
  end
  p res if do_debug
  res
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
  p VcfHeader::RagelKeyValues.run_lexer(s, debug: false)
}

end